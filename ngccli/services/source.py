#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ngccli.base import Service
from ngccli.services.source_drivers.default import *

#------------------------------------------------------------------------------#
# Source handler.
#------------------------------------------------------------------------------#

class NGCSource(Service):

	#---------------------------------------------------------------------------#
	# Initialization.
	#---------------------------------------------------------------------------#

	def __init__(self, subparsers):

		"""
		"""

		# get a command-line parser
		self.parser = subparsers.add_parser('source',
			help='Service to generate sourcefile templates.')

		# add command-line options
		self.parser.add_argument('-t', '--template', action="store_true",
			help='create a templated class prototype')

		self.parser.add_argument('-b', '--baseclass', action="store_true",
			help='create a base class from which other classes can derive')

		self.parser.add_argument('-c', '--ccfile', action="store_true",
			help='genefate a c++ source file (in addition to the header)')

		self.parser.add_argument('classname',
			help='the name of the class.' +
				'  This name will also be used for the output file' +
				' unless the -f option is specified explicitly.')

		self.parser.add_argument('-f', '--filename', action="store",
			help='output file base name.' +
				'  If this argument is not provided,' +
				' output file names will be created using the classname')

		# set the callback for this sub-command
		self.parser.set_defaults(func=self.main)

	# __init__

	#---------------------------------------------------------------------------#
	# Main.
	#---------------------------------------------------------------------------#

	def main(self, args=None):

		"""
		"""

		create_cpp_files(args)
		
	# main

	#---------------------------------------------------------------------------#
	# Object factory for service creation.
	#---------------------------------------------------------------------------#

	class Factory:
		def create(self, subparsers): return NGCSource(subparsers)

# class NGCSource
