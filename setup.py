#! /usr/bin/env python
#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import glob
import ngccli
from setuptools import setup, find_packages

# This is for future requirements
requires = []

setup_options = dict(
	# module name
	name = 'ngccli',

	# module version
	version = ngccli.__version__,

	# description
	description = 'Command Line Environment for NGC',

	# long description from README
	long_description = open('README.rst').read(),

	# author
	author = 'Ben Bergen',

	# contact email
	author_email = 'bergen@lanl.gov',

	# scripts to install
	scripts = ['bin/ngc'],

	# packages
	packages = find_packages('.', exclude=['tests*']),

	# package dir
	package_dir = {'ngccli' : 'ngccli'},

	# license
	license = 'NONE'
)

# call setup
setup(**setup_options)
