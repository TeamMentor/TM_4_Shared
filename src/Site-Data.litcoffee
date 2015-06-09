This class provide support for loading config (and other values) from
SiteData repo

    require 'fluentnode'
    path           = require 'path'
    fs             = require 'fs'
    static_Strings = require './static-Strings'

    class Site_Data

      constructor: (options)->
        @._options = options || {}

      config_Folder: ()=>
        __dirname.path_Combine static_Strings.RELATIVE_PATH_TO_CONFIG_FOLDER

      options: ()=>
        @._options

      load_Options: ()=>
        tmConfig_File = @.siteData_TM_Config()?.real_Path()
        if tmConfig_File?.file_Exists()                                     # if @.siteData_TM_Config exists
          tmConfig = tmConfig_File.load_Json()                              # load as json
          if (tmConfig)                                                     # if data was loaded ok
            @._options = tmConfig                                           # set @.options with loaded object
        @.options()


siteData_Folder:

This method calculates the location of the SiteData using the following formula

* if there is a SiteData folder inside the @.config_Folder() use it
* if the TM_SITE_DATA environment variable exists:
** if it is a full path use it
** combine its value with @.config_Folder()

      siteData_Folder: ()=>
        config_SideData = @.config_Folder().path_Combine static_Strings.DEFAULT_SITE_DATA
        if config_SideData and config_SideData.folder_Exists()
          return config_SideData

        env_Site_Data = process.env[static_Strings.ENV_TM_SITE_DATA]

        if env_Site_Data
          if env_Site_Data.folder_Exists()
            return env_Site_Data
          else
            log @.config_Folder
            return @.config_Folder.path_Combine env_Site_Data

siteData_TM_Config:

This is the tm.config.json file used by @.load_Options

      siteData_TM_Config: ()=>
        @.siteData_Folder()?.path_Combine static_Strings.TM_CONFIG_FILENAME

    module.exports = Site_Data