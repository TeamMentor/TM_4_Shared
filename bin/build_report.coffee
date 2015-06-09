#!/usr/bin/env coffee

require 'fluentnode'
fs = require 'fs'

lcov_File = './coverage/coverage-coffee.json'
if lcov_File.file_Exists()
  "monitoring changes to file: #{lcov_File}".log()
  fs.watchFile lcov_File, (current)->
    "File #{lcov_File} changed, triggering report build".log()

    "./node_modules/.bin/istanbul".start_Process_Redirect_Console 'report'
