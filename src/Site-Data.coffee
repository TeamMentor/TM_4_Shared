# This class provide support for loading config (and other values) from
# SiteData repo

require 'fluentnode'
path           = require 'path'
fs             = require 'fs'
static_Strings = require './static-Strings'

class Site_Data

  # @.**constructor**()

  constructor: (options)->
    @._options = options || {}

# **config_Folder:** Tries to find a 'config' folder in one of the parent folders of the current directory (__dirname)

  config_Folder: ()=>
    folder = __dirname
    while folder isnt (folder = folder.parent_Folder())
      target = folder.path_Combine static_Strings.FOLDER_CONFIG
      if target.file_Exists()
        return target

# @.**options**()

  options: ()=>
    @._options

# @.**load_Custom_Code**()

# Finds coffee script files inside @.siteData_Folder() and loads them into
# the globals.custom object

  custom_Code: ()=>
    #global.custom ?= {}
    custom_Code = {}
    files = @.siteData_Folder().files_Recursive('.coffee')
    if files.not_Empty()
      for file in files
        custom_Code[file.file_Name_Without_Extension()] = require file

      "[SiteData] Custom code loaded: #{custom_Code.keys_Own()}".log()
    custom_Code

# @.**load_Options:**()

# if @.siteData_TM_Config exists, load as json and set @._options with loaded object

  load_Options: ()=>
    tmConfig_File = @.siteData_TM_Config()?.real_Path()
    if tmConfig_File?.file_Exists()
      @._options = tmConfig_File.load_Json()
    @.options()

# @.**siteData_Folder:**()

# Calculates the location of the SiteData using the following formula
#
# * If there is a SiteData folder inside the config_Folder() use it
# * If the ENV_TM_SITE_DATA environment variable exists: use it
# * If the ENV_TM_SITE_DATA environment variable doesn't exists: combine its value with .config_Folder()

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

# @.**siteData_TM_Config:**()

# This is the tm.config.json file used by @.load_Options

  siteData_TM_Config: ()=>
    @.siteData_Folder()?.path_Combine static_Strings.TM_CONFIG_FILENAME


module.exports = Site_Data