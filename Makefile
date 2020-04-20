
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
	python3 -m range_dl -k "http://upos-sz-mirrorcos.bilivideo.com/upgcxcode/61/00/129360061/129360061-1-30077.m4s\?e\=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M\=\&uipk\=5\&nbs\=1\&deadline\=1587396317\&gen\=playurl\&os\=cosbv\&oi\=1875304758\&trid\=e817c68ecd7947f4aa1d59a1e8c52747u\&platform\=pc\&upsig\=bbf8403d51bc173013925724fa375d34\&uparams\=e,uipk,nbs,deadline,gen,os,oi,trid,platform\&mid\=0\&logo\=80000000" -H '{"Host": "qdall01.baidupcs.com"}'| mpv - 
bi:
	python3 -m range_dl -k "http://upos-sz-mirrorcos.bilivideo.com/upgcxcode/61/00/129360061/129360061-1-30077.m4s\?e\=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M\=\&uipk\=5\&nbs\=1\&deadline\=1587396317\&gen\=playurl\&os\=cosbv\&oi\=1875304758\&trid\=e817c68ecd7947f4aa1d59a1e8c52747u\&platform\=pc\&upsig\=bbf8403d51bc173013925724fa375d34\&uparams\=e,uipk,nbs,deadline,gen,os,oi,trid,platform\&mid\=0\&logo\=80000000" | mpv - 

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
