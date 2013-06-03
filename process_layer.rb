require "./network_layer"

#the Process Layer does all file processing
#on the local disk

class ProcessLayer
  #get unix home directory
  @home = Dir.home
  @DIR = "#{@home}/bin/nvCL/"

  #
  #network setup helper methods
  #
  def self.have_credentials?
    if(File.exists?("#{@home}/bin/nvCL/.token.txt"))
      return true
    else return false
    end
  end

  def self.saved_credentials
    token_string = File.open("#{@home}/bin/nvCL/.token.txt").read
  end

  #store session for later
  def self.store_session(serialized_session)
    self.bin
    self.nvCL
    self.write_session(serialized_session)
  end

  def self.bin
    if !Dir.exists?("#{@home}/bin")
      puts "creating new directory #{@home}/bin"
      Dir.mkdir("#{@home}/bin")
    end
  end

  def self.nvCL
    if !Dir.exists?("#{@home}/bin/nvCL")
      puts "creating new directory #{@home}/bin/nvCL"
      Dir.mkdir("#{@home}/bin/nvCL")
    end
  end

  def self.write_session(serialized_session)
    File.open("#{@home}/bin/nvCL/.token.txt", 'w') do |f|
      f.puts serialized_session
    end
  end

  #
  #network output helper methods
  #
  def self.write_data(filename, out)
    unless out==false
      File.open("#{@DIR}#{filename}", "w"){|f| f.puts out}
    end
  end

  #called after edits
  def self.delete(filename)
    if File.exists?("#{@DIR}#{filename}")
      File.delete("#{@DIR}#{filename}")
    else puts "file not found"
    end
  end

  def self.parse_search(response)
    if response.length>0
      #call UI layer
      response.each do |i|
        puts "> #{i['path'].sub('/','')}"
      end
    else
      #send error to UI layer
    end
  end

  def self.parse_list(metadata)
    if metadata['contents'].length>0
      file_metadata['contents'].each do |i|
        puts "> #{i['path'].sub('/','')}"
      end#call UI layer

    else
      #send error to UI layer
    end
  end

  def self.parse_link(media)
    if media['url']!= nil
      #call UI layer
      puts "file available at #{link_data['url']}"
      puts "until #{link_data['expires']}"
    else
      #send error to UI layer
    end
  end
end
