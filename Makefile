
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
	python3 -m range_dl  "https://qdall01.baidupcs.com/file/ed7be9e026190231f5cf305f7b543534?bkt=en-cf7b18a7c51d9078181688bc37ce9a34eacd2852d34d04a8b2e0ea74633874bc96f2c45a7179802e&fid=1744894658-250528-392516672940772&time=1586604718&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-NdA117r%2FnrbsTaOExEu8Gzp0sWE%3D&to=92&size=354480261&sta_dx=354480261&sta_cs=26688&sta_ft=mp4&sta_ct=7&sta_mt=7&fm2=MH%2CYangquan%2CAnywhere%2C%2C%E5%8C%97%E4%BA%AC%2Ccnc&ctime=1527791069&mtime=1538767282&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=354480261&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-6fa413b304f1f4ddd13ba3a1e0c6959f243b4c7da66c22233df1c0014705e7bac6cd849854df5d8e&sl=69533774&expires=8h&rt=pr&r=577598554&mlogid=MjAyMDA0MTExOTMxNTg0MDYsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksMzg4Mg%3D%3D&vbdid=4239862960&fin=Friends.S06E01.1999.BluRay.720p.x264.AAC-iSCG.mp4&bflag=92,34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663675629878084549&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=6271d6a92c89ad8b2a7c88032977ffd2e595d2fc1e06fbad&reqlabel=250528_l_0d379c25691f1db02fd2dff786ffd19a_-1_b47a1c84a207d217ae9410ea0984f09f&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=0" -wo a.mp4  

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
