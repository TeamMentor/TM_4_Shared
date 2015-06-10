#!/usr/bin/env coffee

# ./node_modules/.bin/istanbul report json-summary

require 'fluentnode'
elasticsearch = require('elasticsearch');
logger = require 'elasticsearch//src/lib/logger'

options =
  host: '10.0.1.46:9200',
  log: 'info'

client = new elasticsearch.Client options

ping = ->
  client.ping hello: "elasticsearch!", (error)->

    if (error)
      console.trace('elasticsearch cluster is down!');
    else
      console.log('All is well')

submit = (file, body)->

  "Sending data for #{file}".log()
  #body =
  #        title: 'Test 1',
  #        tags: ['y', 'z'],
  #        published: true,
  body.timestamp = logger.prototype.timestamp()
  body.file      = file
  data =
          index: 'coverage'
          type: 'coverage',
          #id: id
          timestamp: logger.prototype.timestamp()
          body: body

  client.index data, (error,response)->
    log error if error
    #log response


#return
coverageFile = './coverage/coverage-summary.json'
coverageData = coverageFile.load_Json()

for key,value of coverageData
  #index = key.file_Name().lower() #.remove(process.cwd())
  file = key.remove(process.cwd())
  submit file, value
