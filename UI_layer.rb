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
        #eventually, this will be search and open
        raise "input not recognized" #for now
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
      notify_observers
      return
    end

    @action.call(self,inputs[1])

  end

end

