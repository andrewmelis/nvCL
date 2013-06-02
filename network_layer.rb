#from https://www.dropbox.com/developers/app_info/321120
require 'dropbox_sdk'

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

    #get unix $HOME directory
    home = Dir.home

    if(File.exists?("#{home}/bin/nvCL/token.txt"))
      puts "loading credentials"
      token_string = File.open("#{home}/bin/nvCL/token.txt").read
      @session = DropboxSession.deserialize(token_string)
    else 
      puts "creating new credentials"
      new_session(home)
    end

  end

  #after new_session, if authorized, 'Notational Data CL' folder in Dropbox/home/Apps directory
  def new_session(home)

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


    #store session for later
    if !Dir.exists?("#{home}/bin")
      puts "creating new directory #{home}/bin"
      Dir.mkdir("#{home}/bin")
    end

    if !Dir.exists?("#{home}/bin/nvCL")
      puts "creating new directory #{home}/bin/nvCL"
      Dir.mkdir("#{home}/bin/nvCL")
    end

    token_string = @session.serialize
    File.open("#{home}/bin/nvCL/token.txt", 'w') do |f|
      f.puts token_string
    end

  end

  #uploading files
  #will overwrite a file of the same name
  #do I want to enable sending string functionality?
  def upload(filename)
    begin
      file = File.open("#{filename}")
      response = @client.put_file("/#{filename}",file,true)
      puts "uploaded: #{filename}"
    rescue
      puts "#{filename} not found"
    end
  end

  #helper function used in list_contents() and search()
  def print_metadata(metadata)

  end

  def list_contents
    puts "listing contents of dropbox nvCL directory"
    file_metadata = @client.metadata('/')
    if file_metadata['contents'].length>0
      file_metadata['contents'].each do |i|
        puts "> #{i['path'].sub('/','')}"
      end
    else
      puts "no notes in your nvCL directory"
    end    
  end

  #retrieves file for quick, "in-place" editing
  #TODO come back to this
  def retrieve(filename)
    puts "retrieving #{filename} "
    out = get(filename)
    #pass the raw data back to another layer in this case? in all download cases? perhaps called process layer?
    unless out==false
      require 'tmpdir'
      Dir.m
      File.open("#{filename}", "w"){|f| f.puts out} #current iteration simply downloads file. must open in tmp vim file soon
    end
  end

  #saves to current local directory
  def download(filename)
    puts "downloading #{filename} to local disk"
    out = get(filename)
    unless out==false
      File.open("#{filename}", "w"){|f| f.puts out} 
    end
  end

  #retrieves temporary public-facing url for given filename
  def link(filename)
    puts "obtaining public-facing link for #{filename}"
    begin
      link_data = @client.media(filename)
      puts "file available at #{link_data['url']}"
      puts "until #{link_data['expires']}"
    rescue DropboxError
      puts "#{filename} not found!"
      return false
    end
  end
     
  #helper function for download and retrive
  #either returns file data or returns false
  def get(filename)
    begin
      out = @client.get_file("#{filename}")
    rescue DropboxError
      puts "#{filename} not found!"
      return false
    end
  end


  #lists all files returned from query
  #add behavior to open a file if there's only one result?
  def search(search_term)
    puts "searching nvCL for #{search_term}"
    response = @client.search('/',"#{search_term}")    #returns metadata in JSON
    if response.length>0
      response.each do |i|
        puts "> #{i['path'].sub('/','')}"
      end
    else
      puts "no notes with the search term #{search_term} in your nvCL directory"
    end
  end

end
