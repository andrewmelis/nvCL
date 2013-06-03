# require './UI_layer'
require './network_facade'

Upload = lambda do |context, filename|

  puts context.network.upload(filename)

end

Download = lambda do |context, filename|
  puts "retrieving #{filename}"
  puts context.network.get(filename)
end

ListContents = lambda do |context, *args|
  puts "listing contents of dropbox nvCL directory"  

  data = context.network.list_contents
  if data.class == String
    puts data
  else
    data['contents'].each do |i|
      puts "> #{i['path'].sub('/','')}"
    end
  end

end

Search = lambda do |context, term|
  puts "searching nvCL for #{term}"  

  data = context.network.search(term)
  if data.class == String
    puts data
  else
    data.each do |i|
      puts "> #{i['path'].sub('/','')}"
    end
  end

end

Link = lambda do |context, filename|
  puts "obtaining public-facing link for #{filename}"
  
  data = context.network.link(filename)
  if data.class == String
    puts data
  else
    puts "file available at #{data['url']}"
    puts "until #{data['expires']}"
  end

end

Help = lambda do |*args|
  system('cat ~/bin/nvCL/.help.txt')
  #TODO write the help file!
end

Web = lambda do |*args|
  exec('open https://www.dropbox.com/home/Apps/Notational Data CL')
end