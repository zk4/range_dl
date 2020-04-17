make curl multihreadable
# Install 

``` bash

pip isntall range_dl
```


# Example 
``` bash
range_dl -c "curl  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3628.2 Safari/537.36' -H 'Referer: https://www.bilibili.com/video/BV1RE411k7aL?p=9'  'http://upos-sz-mirrorhw.bilivideo.com/upgcxcode/76/51/127435176/127435176-1-30066.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&uipk=5&nbs=1&deadline=1587141766&gen=playurl&os=hwbv&oi=1875304758&trid=3f395db327314ad499b5d607fe81aca9u&platform=pc&upsig=135d6d1c9664c0b496a7bd5a80051d93&uparams=e,uipk,nbs,deadline,gen,os,oi,trid,platform&mid=0&logo=80000000'" | mpv -

```


# Full Usage
```
usage: range_dl [-h] [-o OUT_PATH] [-p PROXY] [-c] [-H HEADERS]
                [-t THREADCOUNT] [-d] [-w] [--version] [-k]
                url

range_dl -c "curl -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3628.2 Safari/537.36' -H
'Referer: https://www.bilibili.com/video/BV1RE411k7aL?p=9' 'http://upos-sz-mir
rorhw.bilivideo.com/upgcxcode/76/51/127435176/127435176-1-30066.m4s?e=ig8euxZM
2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N0
3eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmM
QJ6mqF2fka1mqx6gqj0eN0B599M=&uipk=5&nbs=1&deadline=1587141766&gen=playurl&os=h
wbv&oi=1875304758&trid=3f395db327314ad499b5d607fe81aca9u&platform=pc&upsig=135
d6d1c9664c0b496a7bd5a80051d93&uparams=e,uipk,nbs,deadline,gen,os,oi,trid,platf
orm&mid=0&logo=80000000'" | mpv -

positional arguments:
  url                   url

optional arguments:
  -h, --help            show this help message and exit
  -o OUT_PATH, --out_path OUT_PATH
                        output path, ex: ./a.mp4 (default: None)
  -p PROXY, --proxy PROXY
                        for example: socks5h://127.0.0.1:5992 (default: None)
  -c, --curl            enalbe curl command in url! parse only header and url
                        (default: False)
  -H HEADERS, --headers HEADERS
                        headers width dict string '{"Host":
                        "qdall01.baidupcs.com"}' (default: None)
  -t THREADCOUNT, --threadcount THREADCOUNT
                        thread count (default: 10)
  -d, --debug           debug info (default: False)
  -w, --overwrite       overwrite existed file (default: False)
  --version             show program's version number and exit
  -k, --ignore_certificate_verfication
                        ignore certificate verfication, don`t use this option
                        only if you know what you are doing! (default: False)
```
# TODO
1. smart range for fast preview, some media file need to read last few bytes.
