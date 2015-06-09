This class provide support for loading config (and other values) from
SiteData repo

    require 'fluentnode'
    path           = require 'path'
    fs             = require 'fs'
    static_Strings = require './static-Strings'

    class Site_Data

      constructor: (options)->
        @._options = options || {}

Tries to find a 'config' folder in one of the parent folders of the current directory (__dirname)

      config_Folder: ()=>
        folder = __dirname
        while folder isnt (folder = folder.parent_Folder())
          target = folder.path_Combine static_Strings.FOLDER_CONFIG
          if target.file_Exists()
            return target

      options: ()=>
        @._options

      load_Options: ()=>
        tmConfig_File = @.siteData_TM_Config()?.real_Path()
        if tmConfig_File?.file_Exists()                                     # if @.siteData_TM_Config exists
          @._options = tmConfig_File.load_Json()                            # load as json and set @._options with loaded object
        @.options()


Calculates the location of the SiteData using the following formula

* if there is a SiteData folder inside the @.config_Folder() use it
* if the ENV_TM_SITE_DATA environment variable exists:
** if it is a full path use it
** combine its value with @.config_Folder()

      siteData_Folder: ()=>
        config_SideData = @.config_Folder().path_Combine static_Strings.FOLDER_SITE_DATA
        if config_SideData and config_SideData.folder_Exists()
          return config_SideData

        env_Site_Data = process.env[static_Strings.ENV_TM_SITE_DATA]

        if env_Site_Data
          if env_Site_Data.folder_Exists()
            return env_Site_Data
          else
            return @.config_Folder().path_Combine env_Site_Data

siteData_TM_Config:

This is the tm.config.json file used by @.load_Options

      siteData_TM_Config: ()=>
        @.siteData_Folder()?.path_Combine static_Strings.TM_CONFIG_FILENAME

    module.exports = Site_Data