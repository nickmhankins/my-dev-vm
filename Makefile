BOX_NAME := dev_vm
CURRENT_DIR := $(shell pwd)
BUILD_VER := $(shell date +"%Y%m%d.%H%M%S")
BUILDERS_DIR := ${CURRENT_DIR}/builders
METADATA_SCRIPT := ${CURRENT_DIR}/metadata.py
VAGRANT_OUTPUT_PATH := ${CURRENT_DIR}/build/${BOX_NAME}-${BUILD_VER}.box

BASE_IMAGE_JSON := ${BUILDERS_DIR}/01-baseimage.json
APPLICATIONS_JSON := ${BUILDERS_DIR}/02-applications.json
VAGRANT_JSON := ${BUILDERS_DIR}/03-output.json

OUTPUT =
ifndef VERBOSE
	OUTPUT = >/dev/null 2>&1
endif

BUILD_CMD := packer build
BASE_IMAGE_CMD := ${BUILD_CMD} ${BASE_IMAGE_JSON} ${OUTPUT}
APPLICATIONS_CMD := ${BUILD_CMD} -force ${APPLICATIONS_JSON} ${OUTPUT}
VAGRANT_CMD := ${BUILD_CMD} -var 'box_name=${BOX_NAME}' -var 'build_version=${BUILD_VER}' -var 'box_output_path=${VAGRANT_OUTPUT_PATH}' ${VAGRANT_JSON} ${OUTPUT}
METADATA_CMD := python3 ${METADATA_SCRIPT} --box_path ${VAGRANT_OUTPUT_PATH} --build_version ${BUILD_VER} --box_name ${BOX_NAME} ${OUTPUT}

BASE_IMAGE_EXISTS := $(shell [ -f ${CURRENT_DIR}/ovf_outputs/base/01_baseimage.ovf ]; echo $$?)
APP_IMAGE_EXISTS := $(shell [ -f ${CURRENT_DIR}/ovf_outputs/applications/02_applications.ovf ]; echo $$?)
PREREQ_PACKER := $(shell which packer >/dev/null 2>&1; echo $$?)
PREREQ_VAGRANT := $(shell which vagrant >/dev/null 2>&1; echo $$?)
PREREQ_PYTHON3 := $(shell which python3 >/dev/null 2>&1; echo $$?)
PREREQ_SUM := $(shell expr $(PREREQ_PACKER) + $(PREREQ_VAGRANT) + $(PREREQ_PYTHON3))

FRESH_BUILD_TARGETS = check_prerequisites
ifndef DESTROY_ALL
	FRESH_BUILD_TARGETS += kinda_clean
	VAGRANT_BOX_CMD = vagrant box update
else
	FRESH_BUILD_TARGETS += omg_clean
	VAGRANT_BOX_CMD = vagrant box add build/metadata.json
endif

help:
	@echo " => fresh_build                     --run all Packer builds, outputs and updates Vagrant box"
	@echo " => fresh_build DESTROY_ALL=true    --remove all Packer builds and Vagrant boxes, run all Packer builds, outputs and adds Vagrant box"
	@echo " => application_refresh             --start Packer build from application install step forward, export and update Vagrant box"
	@echo " => box_refresh                     --start Packer build from Vagrant box export step, update Vagrant box"

fresh_build: ${FRESH_BUILD_TARGETS}
	@echo "Starting build from scratch..."
	@${BASE_IMAGE_CMD} && \
	${APPLICATIONS_CMD} && \
	${VAGRANT_CMD} && \
	${METADATA_CMD} && \
	${VAGRANT_BOX_CMD}

application_refresh: check_prerequisites
ifeq ($(BASE_IMAGE_EXISTS), 0)
	@echo "Rebuilding application image, exporting a Vagrant box, and incrementing the metadata version..."
	@${APPLICATIONS_CMD} && \
	${VAGRANT_CMD} && \
	${METADATA_CMD} && \
	${VAGRANT_BOX_CMD}
else
	@echo "Starting image not found, run a fresh build first"
endif

box_refresh: check_prerequisites
ifeq (${APP_IMAGE_EXISTS}, 0)
	@echo "Exporting a new Vagrant box from existing application image and incrementing the metadata version..."
	@${VAGRANT_CMD} && \
	${METADATA_CMD} && \
	${VAGRANT_BOX_CMD}
else
	@echo "Application image not found, run a fresh build first"
endif
	
check_prerequisites:
ifeq (${PREREQ_SUM}, 	0)
	@echo "All prerequisites met"
else
	@echo "Prerequisite status:"
	@echo "	Packer  => $(shell [[ ${PREREQ_PACKER} -gt 0 ]] && echo "Not found" || echo "OK")"
	@echo "	Vagrant => $(shell [[ ${PREREQ_VAGRANT} -gt 0 ]] && echo "Not found" || echo "OK")"
	@echo "	Python3 => $(shell [[ ${PREREQ_PYTHON3} -gt 0 ]] && echo "Not found" || echo "OK")"
endif
	
kinda_clean:
	@echo "Cleaning up output files and other stray files..." 
	@rm -rf $(CURRENT_DIR)/ovf_outputs/*
	@rm -rf $(CURRENT_DIR)/build.*

omg_clean: kinda_clean
	@echo "Cleaning up all Vagrant boxes and metadata..."
	@vagrant destroy --force >/dev/null 2>&1 || :
	@vagrant box remove ${BOX_NAME} --all --force >/dev/null 2>&1 || :
	@rm -rf $(CURRENT_DIR)/.vagrant
	@rm -rf $(CURRENT_DIR)/build/*.box
	@rm -rf $(CURRENT_DIR)/build/metadata.json
