soft=libmksh
softdir=usr/local/lib/mksh

all: build

build: test

test: test_L00mksh_core test_load_mksh test_L10logging test_L11clean_exit test_L11locks test_L90version

test_L00mksh_core:
	chmod +x test/L00mksh_core_test.sh
	test/L00mksh_core_test.sh		

test_load_mksh:
	chmod +x test/load_mksh_test.sh
	test/load_mksh_test.sh

test_L10logging:
	chmod +x test/L10logging_test.sh
	test/L10logging_test.sh

test_L11clean_exit:
	chmod +x test/L11clean_exit_test.sh
	test/L11clean_exit_test.sh

test_L11locks:
	chmod +x test/L11locks_test.sh
	test/L11locks_test.sh

test_L90version:
	chmod +x test/L90version_test.sh
	test/L90version_test.sh

install: uninstall copy

copy:
	mkdir -p $(DESTDIR)$(prefix)/$(softdir)
	chmod +x src/*
	cp src/* $(DESTDIR)$(prefix)/$(softdir)/

uninstall:
	rm -rf $(DESTDIR)$(prefix)/$(softdir)/
