PYTHON=python

NAME=$(shell ${PYTHON} setup.py --name)
LOWER_NAME  = $(shell echo $(NAME) | tr A-Z a-z)
VERSION=$(shell ${PYTHON} setup.py --version)
SDIST=dist/${NAME}-${VERSION}.tar.gz
VENV=/tmp/venv

.PHONY: dist_zip dist_deb


dist: clean compile_locales manpage
	${PYTHON} setup.py sdist

dist_deb: dist
	mkdir dist_deb
	cp dist/${NAME}-${VERSION}.tar.gz dist_deb/${LOWER_NAME}_${VERSION}.orig.tar.gz
	cd dist_deb && tar -xvzf ${LOWER_NAME}_${VERSION}.orig.tar.gz
	cd dist_deb/${NAME}-${VERSION} && ${PYTHON} setup.py --command-packages=stdeb.command debianize --extra-cfg-file setup.cfg
	cp CHANGELOG dist_deb/${NAME}-${VERSION}/debian/changelog
	echo 'lucky-luks.1.gz usr/share/man/man1' >> dist_deb/${NAME}-${VERSION}/debian/${PYTHON}-${LOWER_NAME}.install
	echo 'lucky-luks usr/bin' >> dist_deb/${NAME}-${VERSION}/debian/${PYTHON}-${LOWER_NAME}.install
	echo 'README.rst usr/share/doc/${PYTHON}-${LOWER_NAME}' >> dist_deb/${NAME}-${VERSION}/debian/${PYTHON}-${LOWER_NAME}.install
	sed -e "s/dh_desktop//g" -i dist_deb/${NAME}-${VERSION}/debian/rules
	cd dist_deb/${NAME}-${VERSION} && debuild -S -sa
 
dist_zip:
	mkdir -p dist_zip
	rm -f dist_zip/${NAME}-${VERSION}
	zip -r ${NAME}-${VERSION} ${NAME}/ __main__.py -i \*.py \*.mo
	echo '#!/usr/bin/env ${PYTHON}' | cat - ${NAME}-${VERSION} > temp && mv temp ${NAME}-${VERSION}
	chmod +x ${NAME}-${VERSION}
	mv ${NAME}-${VERSION} dist_zip/

# these would work if stdeb could handle additional files (manpage etc) && custom changelog
# use dist_deb target instead and build binary package manually if needed
#deb_src: clean manpage
#	${PYTHON} setup.py --command-packages=stdeb.command sdist_dsc --extra-cfg-file setup.cfg
#	debsign deb_dist/${LOWER_NAME}_${VERSION}*_source.changes

#deb_bin: deb_src
#	cd deb_dist/${NAME}-${VERSION} && debuild -us -uc

# TODO: test ... someday
#rpm:
#	${PYTHON} setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall

update_locales:
	python2 setup.py extract_messages --output-file ${NAME}/locale/${NAME}.pot
	python2 setup.py update_catalog --domain ${NAME} --input-file ${NAME}/locale/${NAME}.pot --output-dir ${NAME}/locale

compile_locales:
	python2 setup.py compile_catalog --domain ${NAME} --directory ${NAME}/locale
	
init_locale:
	if test -z "$$NEW_LANG";\
	then echo 'please provide a language eg. `make init_locale NEW_LANG="LANGCODE"`';\
	else ${PYTHON} setup.py init_catalog -l ${NEW_LANG} -i ${NAME}/locale/${NAME}.pot -d ${NAME}/locale; fi;

manpage:
	help2man -n 'GUI for creating and unlocking LUKS/TrueCrypt volumes from container files' -N --no-discard-stderr ./lucky-luks | gzip -9 > lucky-luks.1.gz

install:
	${PYTHON} setup.py install --install-layout=deb

check:
	@echo '### pylint check ###'
	find . -name \*.py | grep -v "^test_" | xargs pylint --errors-only --additional-builtins=_,format_exception --reports=n
	@echo '### pep8 check ###'
	pep8  *.py ./luckyLUKS --ignore=E501
#	autopep8 ./luckyLUKS --in-place --verbose --ignore=E501

#deploy:
#	# make sdist
#	rm -rf dist
#	python setup.py sdist
#
#	# setup venv
#	rm -rf $(VENV)
#	virtualenv --no-site-packages $(VENV)
#	$(VENV)/bin/pip install $(SDIST)

#upload:
#	${PYTHON} setup.py sdist register upload

clean:
	${PYTHON} setup.py clean
	rm -rf build/ dist build ${NAME}-${VERSION} ${NAME}.egg-info deb_dist dist_zip dist_deb debian lucky-luks.1.gz
	find . -name '*.pyc' -delete
