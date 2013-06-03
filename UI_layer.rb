require './strategies'
require './network_facade'
require './network_observer'

class UI
  include ConnectionObserver

  attr_accessor :action, :network

  def initialize
    @network = NetworkFacade.new 
    
    super()         #instantiate ConnectionObserver module
    add_observer &ConnectionDown
  end

  def read_inputs(inputs)
    if inputs.size==2
      cmd = inputs[0].downcase
      if cmd == "d" || cmd == "download"
        set_action &Download
      elsif cmd == "p" || cmd == "public"
        set_action &Public
      elsif cmd == "s" || cmd == "search"
        set_action &Search
      elsif cmd == "u" || cmd == "upload"
        set_action &Upload
      elsif cmd == "o" || cmd == "open"
        set_action &Open
      elsif cmd == "e" || cmd == "edit"
        set_action &Edit
      elsif cmd == "n" || cmd == "new"
        set_action &Edit
      else
        # set_action &Append
        raise "come back later"
      end

    elsif inputs.size==1
      cmd = inputs[0].downcase
      if cmd == "h" || cmd == "help"
        set_action &Help
      elsif cmd == "w" || cmd == "web"
        set_action &Web
      elsif cmd == "l" || cmd == "list"
        set_action &ListContents
      else
        set_action &Omnibar
      end
    elsif inputs.size==0
      set_action &ListContents
    else
      raise "input not recognized"
    end   
  end

  def set_action &action
    @action = action
  end


  def run(inputs)
    read_inputs(inputs)

    #check connection
    if !NetworkHelper.instance.check
      notify_observers                  #observer called
      return
    end

    if(inputs[1]==nil)
      @action.call(self,inputs[0])  #for omnibar
    else
      @action.call(self,inputs[1])
    end

  end

end

