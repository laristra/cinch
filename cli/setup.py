#! /usr/bin/env python2
#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import os
import glob
import cinch
from setuptools import setup, find_packages

# This is for future requirements
requires = []

setup_options = dict(
	# module name
	name = 'cinch',

	# module version
	version = cinch.__version__,

	# description
	description = 'Command Line Environment for cinch',

	# long description from README
	long_description = open('README.rst').read(),

	# author
	author = 'Ben Bergen',

	# contact email
	author_email = 'bergen@lanl.gov',

	# scripts to install
	scripts = ['bin/cinch'],

	# packages
	packages = find_packages('.', exclude=['tests*']),

	# package dir
	package_dir = {'cinch' : 'cinch'},

	# license
	license = 'NONE'
)

import sys
if not sys.version_info[0] == 2:
    print "Sorry, Python 3 is not supported (yet)"
    sys.exit(1)

# call setup
setup(**setup_options)
