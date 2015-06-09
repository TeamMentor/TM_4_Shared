# This class provides support for global config values

    static_Strings = require './static-Strings'

    class Config

      constructor: (options)->
        @.options = options || {}

      cache_Folder: ()=>
        process.cwd().path_Combine static_Strings.FOLDER_TM_CACHE

      jade_Compilation: ()=>
        @.cache_Folder().path_Combine static_Strings.FOLDER_JADE_COMPILATION

      jade_Cache: ()=>
        return @.options?.enable_Jade_Cache || false

    module.exports = Config
