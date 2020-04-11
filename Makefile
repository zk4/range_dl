
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
	python3 -m range_dl  "https://qdall01.baidupcs.com/file/14e3ef5152b6e1791a2695a0ecdfd685?bkt=en-40ebf341379bd9a0b6020053878a066d788cf90d2dc84267d6b1149be5280b0fb497e44c48e67a6ccd13461a74e8a7d952205b9d78760e70add667dbb5bbf9fc&fid=1744894658-250528-932705172299193&time=1586621634&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-nYY2dJJ9%2Bp%2FopQWO3BWBrg%2BMxEc%3D&to=92&size=365360721&sta_dx=365360721&sta_cs=33505&sta_ft=mp4&sta_ct=7&sta_mt=7&fm2=MH%2CQingdao%2CAnywhere%2C%2C%E5%8C%97%E4%BA%AC%2Ccnc&ctime=1527791056&mtime=1538767282&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=365360721&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-07d6fd917704a188e50f2ae0af92ff34ea7a5952e050ac6d656e22a8c26774d84fe5045bfa2b5a05f3a686a98c910b63fdcfa84f136f865f305a5e1275657320&sl=69533774&expires=8h&rt=pr&r=668649609&mlogid=MjAyMDA0MTIwMDEzNTM0MDcsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksMzk1Nw%3D%3D&vbdid=1578711455&fin=Friends.S01E02.1994.BluRay.720p.x264.AAC-iSCG.mp4&bflag=92,34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663693366004438169&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=0887d9faa0e99264151b48d235608bcfb8e59433b34465fe305a5e1275657320&reqlabel=250528_l_0d379c25691f1db02fd2dff786ffd19a_-1_b47a1c84a207d217ae9410ea0984f09f&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=0" | mpv - 

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
