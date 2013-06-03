require "./network_layer"
require 'fileutils'

#the Process Layer does all file processing
#on the local disk

class ProcessLayer
  #get unix home directory
  @home = Dir.home
  @DIR = "#{@home}/bin/nvCL/"

  ##############################
  #network setup helper methods
  ##############################
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

  ##############################
  #network output helper methods
  ##############################

  #used in retrieve
  #TODO figure out if going to write to current directory or to bin
  def self.write_data(filename, out)
    unless out==false
      # File.open("#{@DIR}#{filename}", "w"){|f| f.puts out}
      File.open("#{filename}", "w"){|f| f.puts out}
      return true
    end
    return false
  end

  #called after edits
  #NOT IMPLEMENTED
  def self.delete_local(filename)
    if File.exists?("#{filename}")
      File.delete("#{filename}")

    # if File.exists?("#{@DIR}#{filename}")
    #   File.delete("#{@DIR}#{filename}")
      return true
    else 
      return false
    end
  end

  def self.open_local(filename, edit)
    ext = File.extname("#{filename}")
    
    if ext == ".jpg" || ext == ".png"
      # Thread.new {system("open #{filename}")  }
      system("open #{filename}")
      sleep(2)    #to make sure can open file before delete
      return "pic"
    elsif ext == ".txt" || ext == ".csv"
      if edit
        system("vim #{filename}") #returns true
      else
        puts "\n\n\n\n#{filename}:\n==========================\n\n"
        system("cat #{filename}") #returns true
        puts "\n\n\n\n"
      end
    else
      return false
    end
  end

  def self.new_local(filename)
    ext = File.extname("#{filename}")
    if ext == ".txt" || ext == ".csv"
      File.new("#{filename}", "w+")
      system("vim #{filename}") #returns true
    else
      raise "omnibar creation behavior not supported for extensions other than .csv or .txt"
    end
  end

end
