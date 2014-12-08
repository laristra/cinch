#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import sys
import string
from collections import OrderedDict

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

class Chapter():

	"""
	"""

	def __init__(self, title):

		"""
		"""

		self.title = title
		self.content = []

	# __init__

	def append(self, content):

		"""
		"""

		self.content.append(content)

	# append

	def print_content(self):

		"""
		"""

		for line in self.content:
			sys.stdout.write(line)
		# for

	# print

	def str_content(self):
		# Don't use any seperator
		return string.join(self.content, '')
	# str_content

#------------------------------------------------------------------------------#
# Document class
#------------------------------------------------------------------------------#

class Document():

	"""
	"""

	def __init__(self, title):

		"""
		"""

		self.chapters = OrderedDict()
		self.title = title

	# __init__

	def title(self):
		return self.title
	# title

	def chapter(self, title):

		"""
		"""

		if not title in self.chapters:
			self.chapters[title] = Chapter(title)

		return self.chapters[title]
	# chapter

	def add_chapter(self, title, obj=None):
		if obj:
			self.chapters[title] = obj
		elif not title in self.chapters:
			self.chapters[title] = Chapter(title)
	# add_chapter			
		
	def delete_chapter(self, title):
		del self.chapters[title]

	def print_content(self):
		for chapter in self.chapters:
			self.chapters[chapter].print_content()
	# print_content

	def write(self, output):
		with open(output, 'w+') as f:
			for chapter in self.chapters:
				f.write(self.chapters[chapter].str_content())
	# write

# Document
