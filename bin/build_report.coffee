#!/usr/bin/env coffee

require 'fluentnode'
fs = require 'fs'

lcov_File = './coverage/coverage-coffee.json'

build_Report = ->
  'rm'.start_Process_Capture_Console_Out './coverage/coverage-summary.json',  (result)->
    log result
    './node_modules/.bin/istanbul'.start_Process_Capture_Console_Out 'report' , (result)->
      log result
      './node_modules/.bin/istanbul'.start_Process_Capture_Console_Out 'report','json-summary' , (result)->
        log result
        './bin/publish-to-elk.coffee'.start_Process_Capture_Console_Out (result)->
          log result

if lcov_File.file_Exists()
  "monitoring changes to file: #{lcov_File}".log()
  fs.watchFile lcov_File, (current)->
    "File #{lcov_File} changed, triggering report build".log()

    #"./node_modules/.bin/istanbul".start_Process_Redirect_Console 'report'
    build_Report()
    #rm ./coverage/coverage-summary.json ; ./node_modules/.bin/istanbul report json-summary ; ./bin/publish-to-elk.coffee

build_Report()