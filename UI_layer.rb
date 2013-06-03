#!/usr/bin/env ruby
require './strategies'
require './network_facade'

class UI
  attr_accessor :action, :network

  def initialize
    @network = NetworkFacade.new 
  end

  def read_inputs(inputs)
    if inputs.size==2
      cmd = inputs[0].downcase
      if cmd == "d" || cmd == "download"
        set_action &Download
      elsif cmd == "l" || cmd == "link"
        set_action &Link
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
      elsif cmd == "list"
        set_action &ListContents
      # elsif cmd == 
      else
        raise "come back later"
      end

    elsif inputs.size==1
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
    @action.call(self,inputs[1])
  end

end

ui = UI.new


ui.run(ARGV)
