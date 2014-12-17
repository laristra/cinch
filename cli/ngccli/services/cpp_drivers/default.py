#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from cppheader import cpp_header_template
from cppsource import cpp_source_template

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_cpp_files(args):

  """
  """

  # Set virtual destructor and add protected section if this is a base class.
  virtual = 'virtual' if args.baseclass else ''
  protected = 'protected:\n\n' if args.baseclass else ''

  # Setup template keywords if the class is templated.
  template = 'template<typename T>\n' if args.template else ''

  # Setup output file names
  hfile = (args.filename if args.filename != None else args.classname) + '.h'
  # Do substitutions on header template
  header_output = cpp_header_template.substitute(
    CLASSNAME=args.classname,
    VIRTUAL=virtual,
    PROTECTED=protected,
    TEMPLATE=template,
    FILENAME=hfile
  )

  # Output to file (will overwrite if it exists)
  fd = open(hfile, 'w')
  fd.write(header_output[1:-1])
  fd.close()

  # Write a source file if requested.
  if args.ccfile:
    # Setup template keywords if the class is templated.
    template = 'template<typename T>\n' if args.template else ''
    template_type = '<T>' if args.template else ''

    cfile = (args.filename if args.filename != None
      else args.classname) + '.cc'

    # Do substitutions on source template
    source_output = cpp_source_template.substitute(
      CLASSNAME=args.classname,
      VIRTUAL=virtual,
      PROTECTED=protected,
      TEMPLATE=template,
      TEMPLATE_TYPE=template_type,
      FILENAME=hfile
    )

    # Output to file (will overwrite if it exists)
    fd = open(cfile, 'w')
    fd.write(source_output[1:-1])
    fd.close()
  # if

# create_cpp_files

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
#
# vim: set expandtab :
#------------------------------------------------------------------------------#
