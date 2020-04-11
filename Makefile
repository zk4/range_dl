
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
	pip3 install  .

uninstall:
	pip3 uninstall -y range_dl

debug:
	python3 -m range_dl "https://doubanzyv1.tyswmp.com/2018/07/26/0vhyINWfXeWIkrJd/playlist.m3u8" -d -k -w -o "./a.mp4" 

run:
	python3 -m range_dl  "https://qdall01.baidupcs.com/file/ddc5b41ba32ff4af868a1465e4940ef0?bkt=en-c58a217c5b5bf7b2b7c9612adc16ec8b323abd833f6a27fa9afc74dfd0c2928b4263f0af82787d15&fid=1744894658-250528-495132252639057&time=1586612242&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-7lOnUFQUlCG6bLvvW6nVNfYAWyw%3D&to=92&size=778333751&sta_dx=778333751&sta_cs=1335&sta_ft=mp4&sta_ct=5&sta_mt=5&fm2=MH%2CYangquan%2CAnywhere%2C%2C%E5%8C%97%E4%BA%AC%2Ccnc&ctime=1571920882&mtime=1579355800&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=778333751&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-a62e7d16359dfd74481da95b94278fe0e865a511b1f621f8181c5e76112e06599035fc0be68d2f21&sl=69533774&expires=8h&rt=pr&r=948954665&mlogid=MjAyMDA0MTEyMTM3MjExNDEsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksNTQwOQ%3D%3D&vbdid=2895976859&fin=1.mp4&bflag=92,34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663683517368965297&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=0887d9faa0e992640f04adbde96fb7bb99aea187eb64b0ff305a5e1275657320&reqlabel=250528_l_0d379c25691f1db02fd2dff786ffd19a_-1_b47a1c84a207d217ae9410ea0984f09f&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=0" -d  -wo a.mp4  

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
