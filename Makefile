
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
	python3 -m range_dl  "https://qdall01.baidupcs.com/file/ea01d7ade57051e08b639f3bec861999?bkt=en-82d2bca2fdceac3fc942908783593311de6d3bb9801c8f7bad809a3e222f669aec7e7e1ac0f9818f&fid=1744894658-250528-728155429695054&time=1586617684&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-SgoIhtWWaxW3shtQforagCOqsDg%3D&to=92&size=618832810&sta_dx=618832810&sta_cs=1560&sta_ft=mp4&sta_ct=7&sta_mt=1&fm2=MH%2CYangquan%2CAnywhere%2C%2C%E5%8C%97%E4%BA%AC%2Ccnc&ctime=1544859901&mtime=1586422396&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=618832810&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-5b63f84a3457620046092c393042cf8fcb23616e60df811f8edc5ca037dc66774d42b2fb4e0d6dce&sl=69533774&expires=8h&rt=pr&r=417070746&mlogid=MjAyMDA0MTEyMzA4MDM4MzIsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksODExOA%3D%3D&vbdid=2197961093&fin=%E8%AF%BE%E6%97%B6%E4%BA%94-%E5%9F%BA%E6%9C%AC%E5%AE%9A%E7%90%86%E7%9A%84%E5%BA%94%E7%94%A8.mp4&bflag=92,34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663689224449685893&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=5f2aaa70d2fd14def5f1ab50f725652f21ee9a90ab30e903&reqlabel=250528_l_0d379c25691f1db02fd2dff786ffd19a_-1_b47a1c84a207d217ae9410ea0984f09f&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=0" | mpv -  

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
