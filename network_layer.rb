#from https://www.dropbox.com/developers/app_info/321120


###AUTHENTICATING THE APP###

# Include the Dropbox SDK libraries
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

  #UPLOADING FILES###
  def upload
    file = File.open('working-draft.txt')
    response = @client.put_file('/magnum-opus.txt',file)
    puts "uploaded:", response.inspect
  end


  def load_session
    if !@session.nil? && @session.authorized?
      return
    end

    #get unix $HOME directory
    home = `echo $HOME`.chomp!

    if(File.exists?("#{home}/bin/nvCL/token.txt"))
      puts "loading credentials"
      token_string = File.open("#{home}/bin/nvCL/token.txt").read
      puts token_string
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

    puts @session.serialize
    File.new("#{home}/bin/nvCL/token.txt", 'w') do |f|
      f.puts @session.serialize
    end

  end

end
