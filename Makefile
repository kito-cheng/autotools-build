BASE_URL:=https://ftp.gnu.org/gnu/
AUTOMAKE_BASE_URL:=${BASE_URL}/automake/
AUTOCONF_BASE_URL:=${BASE_URL}/autoconf/
PWD:=$(shell pwd)

.SECONDARY:

src/automake-%.tar.gz:
	mkdir -p src/
	cd src && wget $(AUTOMAKE_BASE_URL)/$(notdir $@)

src/automake-%: src/automake-%.tar.gz
	mkdir -p src
	cd src && tar -zxf $(notdir $<)
	touch $@

build/automake-%: src/automake-%
	mkdir -p $@
	cd $@ && ${PWD}/src/$(notdir $@)/configure --prefix=${PWD}/install/$(notdir $@)
	cd $@ && $(MAKE)
	cd $@ && $(MAKE) -j1 install

install/automake-%: build/automake-%
	touch $@

automake-%: install/automake-%
	@echo $@ build done

src/autoconf-%.tar.gz:
	mkdir -p src/
	cd src && wget $(AUTOCONF_BASE_URL)/$(notdir $@)

src/autoconf-%: src/autoconf-%.tar.gz
	mkdir -p src
	cd src && tar -zxf $(notdir $<)
	touch $@

build/autoconf-%: src/autoconf-%
	mkdir -p $@
	cd $@ && ${PWD}/src/$(notdir $@)/configure --prefix=${PWD}/install/$(notdir $@)
	cd $@ && $(MAKE)
	cd $@ && $(MAKE) -j1 install

install/autoconf-%: build/autoconf-%
	touch $@

autoconf-%: install/autoconf-%
	@echo $@ build done

clean:
	rm -rf install src build
