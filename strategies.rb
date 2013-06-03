# require './UI_layer'
require './network_facade'


#each of these strategies is the UI implementation of a given
#function supported by the app

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

Public = lambda do |context, filename|
  puts "obtaining public-facing link for #{filename}"
  
  data = context.network.public(filename)
  if data.class == String
    puts data
  else
    puts "file available at #{data['url']}"
    puts "until #{data['expires']}"
  end

end

Help = lambda do |*args|
  puts "\n\n\n\nWelcome to nvCL, by Andrew Melis"
  puts "This project was made for CSPP51050\n\n"
  puts "In general, you use the utility in this fashion:\n\n"
  puts "\t$ nvCL <_command_> <_param_>\n\n"
  puts "Valid commands are:\n\n\n\n"
  puts "download, upload, list, search, public, web, and help\n\n\n"
  puts "-download, upload, and public take a filename as their parameter"
  puts "note: unfortunately, nvCL only supports files in the current working directory at this time"
  puts "\n-search takes a search term; a list of files containing the term in their filename will be printed"
  puts "-list displays all your notes"
  puts "-public creates a temporary, public-facing url for the filename you input, as long as that file is already in nvCL"
  puts "-web opens your nvCL notes directory in your default browser"
  puts "-help displays this tutorial"
  puts "\nin addition, you can enter the first letter of any of these commands instead of the entire word"
end

Web = lambda do |*args|
  exec('open https://www.dropbox.com/home/Apps/Notational\ Data\ CL')
end

History = lambda do |*args|
  system('cat ~/bin/nvCL/.history.txt')
end




