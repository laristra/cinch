#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from ngccli.base import Service

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

class NGCSource(Service):

	def __init__(self, subparsers):

		"""
		"""

		# get a command-line parser
		self.parser = subparsers.add_parser('source', help='source help')

		# add command-line options
		self.parser.add_argument('-t', '--template', action="store_true",
			help='create a templated class prototype')

		self.parser.add_argument('-b', '--baseclass', action="store_true",
			help='create a base class from which other classes can derive')

		self.parser.add_argument('classname',
			help='the name of the class.' +
				'  This name will also be used for the output file' +
				' unless the -f option is specified explicitly.')

		self.parser.add_argument('-f', '--filename', action="store",
			help='output file base name.' +
				'  If this argument is not provided,' +
				' output file names will be created using the classname')

		self.parser.set_defaults(func=self.main)
	# __init__

	def main(self, args=None):

		"""
		"""

		print args.classname
		print args.filename
		print args.template
		print args.baseclass

	#---------------------------------------------------------------------------#
	#---------------------------------------------------------------------------#

	class Factory:
		def create(self, subparsers): return NGCSource(subparsers)

# class NGCSource
