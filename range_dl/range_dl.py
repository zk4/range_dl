#coding: utf-8

from concurrent.futures import ThreadPoolExecutor
from os.path import join,basename,dirname
from pathlib import Path
from urllib.parse import urljoin
import argparse
import logging
import os
import random
import queue
import requests
import subprocess
import threading
import tempfile
import uuid
import time
from Crypto.Cipher import AES
import sys
from .progress2 import  pb2

# don`t show verfication warning
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)



from .D  import D,userDefineVisual
from .logx import setup_logging

# don`t remove this line 
setup_logging()

logger = logging.getLogger(__name__)

# proxies={"https":"socks5h://127.0.0.1:5992","http":"socks5h://127.0.0.1:5992"}
headers = {
    'user-agent': 'netdisk;2.2.3;pc;pc-mac;10.14.6;macbaiduyunguanjia' ,
}

def userDefineVisual2(tag, nowValue, fullValue,extrainfo):
    bar_length = 100
    percent = float(nowValue) / fullValue
    arrow = '#' * int(round(percent * bar_length) - 1) + '#'
    spaces = ' ' * (bar_length - len(arrow))
    return "{2} [{0}] {1}%".format(arrow + spaces, int(round(percent * 100)), tag)



class range_dl(object):

    def __init__(self,url,out_path,proxy,not_verify_ssl,debug):
        pool_size           = 10
        self.proxies        = {"https":proxy,"http":proxy}
        self.verify         = not not_verify_ssl
        self.url            = url
        self.is_http_url    = url.startswith("http")
        self.out_path       = out_path
        self.session        = self._get_http_session(pool_size, pool_size, 5)
        # self.ts_list        = [urljoin(self.url, n.strip()) for n in self.m3u8_content.split('\n') if n and not n.startswith("#")]
        self.debug          = debug


        self.length         = self.get_content_size()
        logger.debug(f'self.length:{self.length}')
        self.limit          = 400        
        self.len_sub        = self.length // self.limit 
        self.diff           = self.length % self.limit

        # self.ts_list_pair   = zip(self.ts_list, [n for n in range(len(self.ts_list))])
        self.next_merged_id = 0
        self.ready_to_merged= set()
        self.downloadQ      = queue.PriorityQueue()
        self.tempdir        = tempfile.gettempdir()
        self.tempname       = str(uuid.uuid4())
        self._lock = threading.RLock()

        if self.out_path:
            outdir              = dirname(out_path)
            if outdir and not os.path.isdir(outdir):
                os.makedirs(outdir)
            if self.out_path and os.path.isfile(self.out_path):
                            os.remove(self.out_path)
    
    def get_content_size(self):
        d = D(proxies=self.proxies,headers=dict(headers),verify=self.verify,debug=self.debug)
        size  = d.getWebFileSize(self.url)
        return size 
        



    def _get_http_session(self, pool_connections, pool_maxsize, max_retries):
        session = requests.Session()
        adapter = requests.adapters.HTTPAdapter(pool_connections=pool_connections, pool_maxsize=pool_maxsize, max_retries=max_retries) 
        session.mount('http://', adapter)
        session.mount('https://', adapter)
        return session



    def download(self,url,i,_min,_max):
        try:
            d = D(proxies=self.proxies,headers=dict(headers),verify=self.verify,debug=self.debug)
            # logger.debug(f'url:{url}')
            pathname = join(self.tempdir,self.tempname,str(i))
            ret = d.download(url,pathname,_min,_max)
            if ret:
                with self._lock:
                    self.ready_to_merged.add(i)
            else:
                logger.debug(f'{i} download fails! re Q')
                self.downloadQ.put((i,_min,_max))

        except Exception as e :
            if self.debug:
                logger.exception(e)


    def target(self):
        while self.next_merged_id < self.limit:
            try:
                idx,_min,_max = self.downloadQ.get(timeout=3)
                self.download(self.url,idx,_min,_max)
            except Exception as e:
                # logger.exception(e)
                pass

    def run(self,threadcount):
        for a in range(threadcount):
            threading.Thread(target=self.target).start()

        threading.Thread(target=self.try_merge).start()
        _min = 0
        for i in range(self.limit):
            _max = _min + self.len_sub

            if _max > self.length: 
                _max = self.length

            self.downloadQ.put((i,_min,_max))
            _min = _max + 1


    def try_merge(self):
        outfile  = None

        pp=pb2.getSingleton()
        if self.out_path:
            outfile = open(self.out_path, 'ab')
        while self.next_merged_id < self.limit:
            dots = random.randint(0,3)*"."
            
            pp.update("total merged ", self.next_merged_id, self.limit,"",userDefineVisual2)
            pp.update("block pending", self.next_merged_id+len(self.ready_to_merged), self.limit,"",userDefineVisual2)
            oldidx = self.next_merged_id
            try:

                if self.next_merged_id in self.ready_to_merged:
                    logger.debug(f'try merge {self.next_merged_id}  ....')
                    with self._lock:
                        self.ready_to_merged.remove(self.next_merged_id)
                    p = os.path.join(self.tempdir,self.tempname, str(self.next_merged_id))

                    infile= open(p, 'rb')
                    o  = infile.read()
                    
                    if  self.out_path:
                        outfile.write(o)
                        outfile.flush()
                    else:
                        sys.stdout.buffer.write(o)
                        sys.stdout.flush()

                    infile.close()

                    self.next_merged_id += 1

                    # os.remove(join(self.tempdir,self.tempname,str(oldidx)))
                else:
                    time.sleep(1)
                    logger.debug(f'waiting for {self.next_merged_id} to merge ')
                    logger.debug(f'unmerged {self.ready_to_merged} active_thread:{threading.active_count()}')
            except Exception as e :
                logger.exception(e)
                try:
                    self.next_merged_id=oldidx
                    os.remove(join(self.tempdir,self.tempname,str(oldidx)))
                    logger.error(f'{oldidx} merge error ,reput to thread')
                    logger.exception(e)

                    _min = self.len_sub * oldidx       
                    _max = self.len_sub * (oldidx + 1)
                    if oldidx == self.limit-1: 
                        _max += self.diff
                    self.downloadQ.put((oldidx,_min,_max))
                except Exception as e2:
                    logger.exception(e)

        if self.out_path:
            outfile.close()
            

def main(args):
    if args.debug:
        logger.setLevel("DEBUG")


    logger.debug(f'args.out_path:{args.out_path}')
    if args.out_path and os.path.exists(args.out_path) and not args.overwrite:
            logger.error(f'{args.out_path} exists! use -w if you want to overwrite it ')
            sys.exit(-1) 

    m = range_dl(
            args.url,
            args.out_path,
            args.proxy,
            args.ignore_certificate_verfication,
            args.debug
            )

    # must ensure 1 for merged thread
    threadcount = args.threadcount + 1
    m.run(threadcount)

def entry_point():
    parser = createParse()
    mainArgs=parser.parse_args()
    main(mainArgs)


def createParse():
    parser = argparse.ArgumentParser( formatter_class=argparse.ArgumentDefaultsHelpFormatter, description="")
    parser.add_argument("url",  help="url")
    parser.add_argument('-o', '--out_path',type=str,  help="output path, ex: ./a.mp4" )
    parser.add_argument('-p', '--proxy',type=str,  help="for example: socks5h://127.0.0.1:5992")
    parser.add_argument('-t', '--threadcount',type=int,  help="thread count" ,default=20)
    parser.add_argument('-d', '--debug', help='debug info', default=False, action='store_true') 
    parser.add_argument('-w', '--overwrite', help='overwrite existed file', action='store_true')  
    mydir = os.path.dirname(os.path.abspath(__file__))
    version =Path(join(mydir,"..","version")).read_text()
    parser.add_argument('--version', action='version', version=version)
    parser.add_argument('-k',  '--ignore_certificate_verfication',help='ignore certificate verfication, don`t use this option only if you know what you are doing!', action='store_true')  


    return parser
