#------------------------------------------------------------------------------#
# Copyright (c) 2014 Los Alamos National Security, LLC
# All rights reserved.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def read_token(token, string):
  offset = string.find(token) + len(token) + 1
  value = string[offset]
  while(string[offset+1] != ')'):
    offset = offset+1
    value = value + string[offset]
  return value
# read_token

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#

def read_tokens(line):
  parsed = {}
  for key in SYMBOLS:
    if SYMBOLS[key] in line:
      parsed[key] = read_token(SYMBOLS[key], line)
    # if
  # for

  return parsed
# read_tokens

special = [
    '\'',
    '"',
    '`'
]

start_delimiters = [
    '<!-- CINCHDOC',
    '% CINCHDOC'
]

single_line_delimiters = [
    '-->',
    '% CINCHDOC'
]

end_delimiters = [
    '-->'
]

def begin_identifier(line):
    for char in special:
        if char in line:
            return False

    for delimiter in start_delimiters:
        if delimiter in line:
            return True
# block_identifier

def single_line_identifier(line):
    for single in single_line_delimiters:
        if single in line:
            return True
# single_line_identifier

def end_identifier(line):
    for end in end_delimiters:
        if end in line:
            return True
# end_identifier

#------------------------------------------------------------------------------#
# Formatting options for emacs and vim.
# vim: set tabstop=4 shiftwidth=4 expandtab :
#------------------------------------------------------------------------------#
