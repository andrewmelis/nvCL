require './network_layer'

class NetworkFacade

  attr_reader :network

  def initialize
    @network = NetworkLayer.new #takes care of making authorization
  end

  def upload(filename)
    if !@network.upload(filename)
      return "#{filename} not found in current directory"
    else
      return "uploaded: #{filename}"  #move this
    end
  end

  def get(filename)
    if !@network.get(filename)
      return "#{filename} not found!"
    else 
      return "#{filename} retrieved!"
    end
  end

  #add behavior to open a file if there's only one result?
  def list_contents
    data = @network.list_contents
    if !data
      return "error retrieving notes from Dropbox"
    elsif data['contents'].length>0
      return data
    else return "no notes in your nvCL directory"
    end
  end

  def search(term)
    data = @network.search(term)
    if !data
      return "error searching for notes with Dropbox"
    elsif data.length>0
      return data
    else
      return "no notes with the search term '#{term} in your nvCL directory"
    end
  end

  def link(filename)
    data = @network.link(filename)
    if !data
      return "error creating link from Dropbox"
    else
      return data
    end
  end

end


