log:=0 # Set log=true to enable packer logging
logpath:="output/packerlog.txt-$$(date +%s)"
packer:=PACKER_LOG=$(log) PACKER_LOG_PATH=$(logpath) packer
build:=$(packer) build
params:=-on-error=ask -timestamp-ui
boxes:=$(wildcard output/*.box)

# Set debug=true to enable the debug flag
ifdef debug
  params:=$(params) -debug
endif

.PHONY: all
all: build

.PHONY: clean
clean: remove
	-rm -rf ./output
	-rm -rf ./tests

.PHONY: build
build: init
	$(build) $(params) .

.PHONY: init
init:
	$(packer) init .
	$(packer) validate .
	$(packer) fmt .

.PHONY: add
add:
	-mkdir tests
	for box in $(boxes); do \
		fullname=$$(echo $$box | cut -f2 -d"/") ; \
		name=$$(echo $$fullname | cut -f1,2 -d"_") ; \
		vagrant box add --name $$name $$box ; \
		mkdir tests/$$name ; \
		cd tests/$$name ; \
		vagrant init $$name ; \
		cd ../../ ; \
	done

.PHONY: remove
remove:
	-for box in $(boxes); do \
		fullname=$$(echo $$box | cut -f2 -d"/") ; \
		name=$$(echo $$fullname | cut -f1,2 -d"_") ; \
		if [ -d "tests/$$name/" ] ; \
		then \
			cd tests/$$name ; \
			vagrant destroy --force ; \
			cd ../../ ; \
		  rm -rf tests/$$name ; \
		fi ; \
		vagrant box remove $$name --force ; \
	done
