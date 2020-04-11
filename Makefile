
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
	python3 -m range_dl  " https://qdall01.baidupcs.com/file/77756ef2e0213e1ea3038214bf0d7f43?bkt=en-3f603aaf96443402662a0133763d10362c867408511f140a5e9efe32f9119d8d5440b598ab41095eadb180da7bbe2563bea8fdad79e36041c9fe1fa476f2d6cf&fid=1744894658-250528-815272274030239&time=1586613790&sign=FDTAXGERLQlBHSKfWa-DCb740ccc5511e5e8fedcff06b081203-g%2BNDEu9L%2F9EjYFUTpfqK%2FRLMEoI%3D&to=92&size=167659402&sta_dx=167659402&sta_cs=14019&sta_ft=rmvb&sta_ct=7&sta_mt=5&fm2=MH%2CQingdao%2CAnywhere%2C%2C%E5%8C%97%E4%BA%AC%2Ccnc&ctime=1450081923&mtime=1581844997&resv0=-1&resv1=0&resv2=rlim&resv3=5&resv4=167659402&vuk=1744894658&iv=2&htype=offconn&randtype=&esl=1&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=en-2e9b06082adbfe1c79b42a94eac91a6a9ff2fefa9b1f4ddaffe2a466d36d03383dd50cd4a7a65055390ddd54d3cd4f72f99308a0d5caecc5305a5e1275657320&sl=69533774&expires=8h&rt=pr&r=371862059&mlogid=MjAyMDA0MTEyMjAzMDk2MzUsNzcxOGNkNDYwNzU0NTAxZWI0M2Y5YmNkMzkwNjViNzksNzY0Mg%3D%3D&vbdid=1655997584&fin=%E5%BD%B1%E8%A7%86%E5%B8%9D%E5%9B%BD%28bbs.cnxp.com%29%5BTVB%5D%5B%E7%9A%86%E5%A4%A7%E6%AC%A2%E5%96%9C%E6%97%B6%E8%A3%85%E7%89%88%5D%5B%E5%9B%BD%E8%AF%AD%5D%5BDVD-RMVB%5D%5B001-002%5D.rmvb&bflag=92,34-92&err_ver=1.0&check_blue=1&rtype=1&devuid=7718cd460754501eb43f9bcd39065b79&dp-logid=1663685142199041816&dp-callid=0.1&hps=1&tsl=250&csl=1000&fsl=-1&csign=xVshjG7Y4PlQdclZPB5P%2Fu7c3v8%3D&so=0&ut=1&uter=-1&serv=1&uc=2464685755&ti=c77a2290e27174be736ff5a281d8f30ea05885496551fb5d305a5e1275657320&reqlabel=250528_l_0d379c25691f1db02fd2dff786ffd19a_-1_b47a1c84a207d217ae9410ea0984f09f&by=themis&gsl=1000&ec=1&method=download&gtchannel=0&gtrate=0"  | mpv -

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
