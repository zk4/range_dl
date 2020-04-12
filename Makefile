
rm:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -type d -iname '*egg-info' -exec rm -rdf {} +
	rm -f .coverage
	rm -rf htmlcov
	rm -rf dist
	rm -rf build
	rm -rf proxy.py.egg-info
	rm -rf .pytest_cache
	rm -rf .hypothesis
	rm -rdf assets
	

test: rm
	pytest -s -v  tests/

coverage-html:
	# --cov where you want to cover
	#  tests  where your test code is 
	pytest --cov=range_dl/ --cov-report=html tests/
	open htmlcov/index.html

coverage:
	pytest --cov=range_dl/ tests/

install: uninstall
	sudo pip3 install  .

uninstall:
	sudo pip3 uninstall -y range_dl

debug:
	python3 -m range_dl "https://doubanzyv1.tyswmp.com/2018/07/26/0vhyINWfXeWIkrJd/playlist.m3u8" -d -k -w -o "./a.mp4" 

run:
	python3 -m range_dl -k "https://119.167.143.12/file/18bf41934f016720d561fab914845a67?bkt=en-26dcfdb4e5ee1a49497b566573fe6fb2e85b328be9baee775b7833320a9379958163211da104a5c9&fid=1744894658-250528-836074380554077&time=1586657957&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-DXdrOrU6PwbcRPcPYTGSXmxiKtM%3D&to=92&size=354960784&sta_dx=354960784&sta_cs=33599&sta_ft=mp4&sta_ct=7&sta_mt=7&fm2=MH%2CYangquan%2CAnywhere%2C%2Cbeijing%2Ccnc&ctime=1527791069&mtime=1538767282&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=354960784&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-c2a2fca1773dfa13305e2cf87ecf2336aeddb9511c81879d8cffa2cb9aa2a0b81a4a551fe9502006&sl=69533774&expires=8h&rt=pr&r=794115048&mlogid=MjAyMDA0MTIxMDE5MTcwOTUsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksMjA0MQ%3D%3D&vbdid=-&fin=Friends.S05E03.1998.BluRay.720p.x264.AAC-iSCG.mp4&bflag=92%2C34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663731454036018037&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=0887d9faa0e992643bf29edd5f8d646afaf6676e1fa626f0305a5e1275657320&reqlabel=250528_l_61393895f5190b7891db9f46d94bffa9_-1_3f21e2f9babd03e2ed1f44df1db98521&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=32768" -H '{"Host": "qdall01.baidupcs.com"}'| mpv - 

stream:
	python3 -m range_dl "https://doubanzyv1.tyswmp.com/2018/07/26/0vhyINWfXeWIkrJd/playlist.m3u8" -k | mpv -
	

all: rm uninstall install run 


pure-all: env-rm rm env install test run


	
upload-to-test: rm
	python3 setup.py bdist_wheel --universal
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*


upload-to-prod: rm auto_version 
	python3 setup.py bdist_wheel --universal
	twine upload dist/*


freeze-only:
	# pipreqs will find the module the project really depneds
	pipreqs . --force

freeze:
	#  pip3 will find all the module not belong to standard  library
	pip3 freeze > requirements.txt


env-rm:
	rm -rdf env


env:
	python3 -m venv env
	. env/bin/activate


convert:
	ffmpeg -i anjia12.mkv -codec copy anjia12_mp4.mp4



auto_version:
	python version.py
