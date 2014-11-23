#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

import sys
import string

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
		return string.join(self.content)
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

		self.chapters = dict()
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

	def print_content(self):
		for chapter in self.chapters:
			self.chapters[chapter].print_content()

	def write(self, output):
		with open(output, 'w+') as f:
			for chapter in self.chapters:
				f.write(self.chapters[chapter].str_content())
	# write

# Document
