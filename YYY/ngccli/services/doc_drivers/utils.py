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
