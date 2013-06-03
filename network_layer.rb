
require 'dropbox_sdk'
require './process_layer'

class NetworkLayer
  attr_accessor :session, :client
  attr_reader :APP_KEY, :APP_SECRET, :ACCESS_TYPE

  def initialize
    @APP_KEY = 'aonbfj90mc8ecnl'
    @APP_SECRET = 'zjdti8y6bubt6rw'
    @ACCESS_TYPE = :app_folder

    load_session
    @client = DropboxClient.new(@session, @ACCESS_TYPE)
  end

  ###AUTHENTICATING THE APP###
  def load_session
    if !@session.nil? && @session.authorized?
      return
    end

    if ProcessLayer.have_credentials?
      puts "loading credentials"
      @session = DropboxSession.deserialize(ProcessLayer.saved_credentials)
    else
      puts "creating new credentials"
      new_session
    end

    puts "credentials loaded properly"

  end

  #after new_session, if authorized, 'Notational Data CL' folder in Dropbox/home/Apps directory
  #from https://www.dropbox.com/developers/app_info/321120
  def new_session

    @session = DropboxSession.new(@APP_KEY, @APP_SECRET)

    #OAuth flow

    #step 1: get a request token
    @session.get_request_token

    #step 2: ask user to authorize linking app to Dropbox account
    authorize_url = @session.get_authorize_url("https://www.dropbox.com/home/Apps/Notational Data CL")

    #make the user sign in and authorize this token
    puts "AUTHORIZING", authorize_url
    `open #{authorize_url}`   #backticks indicate a bash command. see http://ruby-doc.org/core-2.0/Kernel.html#method-i-__method__
    puts "Please visit this website and press the 'Allow' button, then hit 'Enter' here." #refactor this step into UI layer? perhaps a notify message?
    gets

    #step 3: once authorized, exchange the request token for an access token, which will be used for calling Core API
    #this will fail if the user didn't visit the above url and hit 'Allow'
    access_token = @session.get_access_token #shouldn't need to get access token again unless reinstall app or revoke access from Dropbox website

    ProcessLayer.store_session(@session.serialize)

  end

  #####################
  #ACTION METHODS
  #####################

  #uploading files
  #will overwrite a file of the same name
  #returns true/false
  def upload(filename)
    begin
      file = File.open("#{filename}")
      response = @client.put_file("/#{filename}",file,true)
      return true
    rescue
      return false
    end
  end

  #helper function for download and retrive
  #returns true/false
  def get(filename)
    begin
      out = @client.get_file("#{filename}")
    rescue DropboxError
      return false
    end
    ProcessLayer.write_data(filename,out) #returns true/false
  end

  #lists all files in nvCL directory
  #returns display data or false
  def list_contents
    begin
      data = @client.metadata('/') #returns this
    rescue DropboxError
      return false
    end
  end

  #lists all files returned from query
  #returns display data or false
  def search(search_term)
    begin
      data = @client.search('/',"#{search_term}")    #returns metadata in JSON
    rescue DropboxError
      return false
    end
  end

  #retrieves temporary public-facing url for given filename
  #returns display data or false
  def link(filename)
    begin
      data = @client.media(filename)
    rescue DropboxError
      return false
    end
  end

end
