#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

from cxxheader import cxx_header_template
from cxxsource import cxx_source_template
import getpass
import datetime
from ccli.services.service_utils import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def create_cxx_files(args):

  """
  """

  # Set virtual destructor and add protected section if this is a base class.
  virtual = 'virtual' if args.baseclass else ''
  protected = 'protected:\n\n' if args.baseclass else ''

  # Setup template keywords if the class is templated.
  template = 'template<typename T>\n' if args.template else ''

  # Setup namespace keywords if a namespace was given.
  namespace_guard = \
    args.namespace.replace("::", "_") + '_' if args.namespace != None else ''

  namespace_start = "namespace " + \
    args.namespace.replace("::", " { namespace ") + \
    " {\n\n" if args.namespace != None else ''

  namespace_end = "} // namespace " + \
    "\n} // namespace ".join(args.namespace.split("::")[::-1]) + "\n\n" \
    if args.namespace != None else ''

  # Setup output file names
  hfile = (args.filename if args.filename != None else args.classname) + '.h'

  # Get the current user and date
  author = getpass.getuser()
  date = datetime.datetime.now().strftime("%b %d, %Y")

  # Setup up spaces to use for tabs
  spaces = tab_spaces(args)

  # Do substitutions on header template
  header_output = cxx_header_template.substitute(
    AUTHOR=author,
    DATE=date,
    SPACES=spaces,
    TABSTOP=args.tabstop,
    CLASSNAME=args.classname,
    VIRTUAL=virtual,
    PROTECTED=protected,
    TEMPLATE=template,
    FILENAME=hfile,
    NAMESPACE_START=namespace_start,
    NAMESPACE_END=namespace_end,
    NAMESPACE_GUARD=namespace_guard
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

    namespace_start = "\nnamespace " + \
      args.namespace.replace("::", " { namespace ") + \
      " {\n" if args.namespace != None else ''

    namespace_end = "\n} // namespace " + \
      "\n} // namespace ".join(args.namespace.split("::")[::-1]) + "\n" \
      if args.namespace != None else ''

    # Do substitutions on source template
    source_output = cxx_source_template.substitute(
      AUTHOR=author,
      DATE=date,
      SPACES=spaces,
      TABSTOP=args.tabstop,
      CLASSNAME=args.classname,
      VIRTUAL=virtual,
      PROTECTED=protected,
      TEMPLATE=template,
      TEMPLATE_TYPE=template_type,
      FILENAME=hfile,
      NAMESPACE_START=namespace_start,
      NAMESPACE_END=namespace_end,
      NAMESPACE_GUARD=namespace_guard
      )

    # Output to file (will overwrite if it exists)
    fd = open(cfile, 'w')
    fd.write(source_output[1:-1])
    fd.close()
  # if

# create_cxx_files

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
#
# vim: set tabstop=2 shiftwidth=2 expandtab :
#------------------------------------------------------------------------------#
