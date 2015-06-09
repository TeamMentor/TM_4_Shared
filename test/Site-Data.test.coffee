fs             = require 'fs'
path           = require 'path'
{expect}       = require 'chai'
Site_Data      = require '../src/Site-Data'
static_Strings = require '../src/static-Strings'


describe '| Site-Data |', ()->
  site_Data = new Site_Data();

  it 'constructor', ->
    site_Data.assert_Is_Object()

  it 'config_Folder', ->
    site_Data.config_Folder()

  #it "Ctor (w/ custom values)", ->
  #   config = new Config()

  #   custom_cache_folder      = '___aaaa'
  #   custom_enable_Jade_Cache = not config.enable_Jade_Cache
  #   custom_config            = new Config(custom_cache_folder, custom_enable_Jade_Cache)

  #   expect(custom_config.cache_folder     ).to.equal(process.cwd() + path.sep + custom_cache_folder)
  #   expect(custom_config.enable_Jade_Cache).to.equal(custom_enable_Jade_Cache)
  #   expect(fs.existsSync(custom_config.cache_folder    )).to.be.false
  #   expect(fs.existsSync(custom_config.jade_Compilation)).to.be.false

  #it 'createCacheFolders', ->
  #    config = new Config()
  #    config.createCacheFolders()
  #    expect(fs.existsSync(config.cache_folder    )).to.be.true
  #    expect(fs.existsSync(config.jade_Compilation)).to.be.true
  #    expect(fs.existsSync(config.library_Data    )).to.be.true

  describe '| with custom SiteData location',->

    folder_Name     = '_tmp_Config'
    siteData_Name   = '_tmp_SiteData'
    config_Folder   = null
    tmConfig        =
      tm_Design:
        port: 12345
      tm_Graph:
        port: 23456

    beforeEach ->
      config_Folder = folder_Name                 .folder_Create()                .assert_Folder_Exists()
      config_Folder.path_Combine(siteData_Name   ).folder_Create()                .assert_Folder_Exists()
                   .path_Combine('TM_4'          ).folder_Create()                .assert_Folder_Exists()
                   .path_Combine('tm.config.json').file_Write(tmConfig.json_Str()).assert_File_Exists()

    afterEach ->
      config_Folder.folder_Delete_Recursive()
                   .assert_True()

    it 'When process.env.TM_SITE_DATA is not set', ->
      using new Site_Data(), ->
        assert_Is_Undefined @.siteData_Folder()
        assert_Is_Undefined @.siteData_TM_Config()

    it 'siteData_Folder (when process.env.TM_SITE_DATA is set to a full path)', ->
      using new Site_Data(), ->
        process.env[static_Strings.ENV_TM_SITE_DATA] = config_Folder
        @.siteData_Folder().assert_Is config_Folder

    it 'siteData_Folder (when process.env.TM_SITE_DATA is set to a virtual path)', ->
      using new Site_Data(), ->
        virtual_Path = "#{siteData_Name}"
        process.env[static_Strings.ENV_TM_SITE_DATA] = virtual_Path
        @.siteData_Folder().assert_Contains virtual_Path
        virtual_Path.folder_Create()
        @.siteData_Folder().assert_Folder_Exists()
                           .folder_Delete()

    it 'siteData_Folder (when SideData folder exists)', ->
      siteData_Folder = config_Folder.path_Combine 'SiteData'
                                     .assert_Folder_Not_Exists()
                                     .folder_Create()
      using new Site_Data(), ->
        @.config_Folder = -> config_Folder
        @.siteData_Folder().assert_Is siteData_Folder
        siteData_Folder.folder_Delete()

    it 'siteData_TM_Config, load_Options, options (when siteData_Folder is valid)', ->
      using new Site_Data(), ->
        virtual_Path = "#{folder_Name}/#{siteData_Name}"
        process.env[static_Strings.ENV_TM_SITE_DATA] = virtual_Path
        @.siteData_TM_Config().assert_File_Exists()
        options = @.load_Options().assert_Is @._options
                                  .assert_Is @.options()
        options.tm_Design.port.assert_Is 12345
        options.tm_Graph.port.assert_Is 23456

        #test corrupted tm.config.json file
        "aaaa".save_As @.siteData_TM_Config()
        @.load_Options().assert_Is {}
        @.siteData_TM_Config().file_Delete()
        @.load_Options().assert_Is {}