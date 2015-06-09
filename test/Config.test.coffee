Config         = require '../src/Config'
static_Strings = require '../src/static-Strings'

describe '| Config |', ()->

  config = new Config();

  it 'constructor', ->
    config.assert_Is_Object()

  it 'cache_Folder', ->
    config.cache_Folder().assert_Is process.cwd().path_Combine static_Strings.FOLDER_TM_CACHE

  it 'jade_Compilation', ->
    config.jade_Compilation().assert_Contains ['.tmCache', 'jade_Compilation']

  it 'jade_Cache', ->
    config.jade_Cache().assert_False()