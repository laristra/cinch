#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from __future__ import generators
import random
import sys
import argparse
from ngccli.factory import *
from ngccli.base import *
from ngccli.utils import *
from ngccli.services import *

#------------------------------------------------------------------------------#
# Internal main routine.  This is the top-level once we are inside of the
# ngccli module.
#------------------------------------------------------------------------------#

def main():

	"""
	"""

	driver = create_clidriver()
	return driver.main()
# main

#------------------------------------------------------------------------------#
# Create the command-line driver.
#------------------------------------------------------------------------------#

def create_clidriver():

	"""
	"""

	driver = CLIDriver()
	return driver
# create_clidriver

#------------------------------------------------------------------------------#
# CLIDriver class
#------------------------------------------------------------------------------#

class CLIDriver():

	"""
	"""

	def __init__(self):

		"""
		"""

		self.parser = argparse.ArgumentParser()
		self.parser.add_argument('service', help='service to execute')
		self.subparsers = self.parser.add_subparsers(help='sub-command help',
			dest='subparser_name')

		self.services = dict()
	# __init__

	def main(self, args=None):

		"""
		"""

		create_services(self.services)

		for s in self.services:
			print s

		self.parser.parse_args()
	# main

# class CLIDriver
