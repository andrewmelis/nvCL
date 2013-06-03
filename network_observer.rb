require 'singleton'

#adapted from Russ Olsen's excellent book,
#Design Patterns in Ruby, 2008
module ConnectionObserver
  
  def initialize
    @observers=[]
  end

  def add_observer(&observer)
    @observers << observer
  end
  
  def delete_observer(observer)
    @observers.delete(observer)
  end
  
  def notify_observers
    @observers.each do |observer|
      observer.call(self)
    end
  end

end


#don't truly need to notify all other observable pieces, because
#this is really "kill" observer
#failure simply quits this execution of app
ConnectionDown = lambda do |context|
  context.network = false
  #raise "connection down, try again later!"  #this kills in unsightly fashion
  puts "connection down, try again later!"
end

class NetworkHelper
  include Singleton

  def check
    begin 
      res = Net::HTTP.get_response(URI('https://www.dropbox.com/home'))
    rescue
      #network down, need to turn off all networks
      return false
    end
  end

end
