require 'rubygems'
require 'appscript'
include Appscript


module SkypeMac
  # Represents a Skype call.  Developer is responsible for calling Call#hangup at the end of each call, whether it was placed
  # by the caller or is an answered call.
  class Call
    @@TOGGLE_FLAGS = [:START, :STOP]
    
    attr :call_id
  
    class << self
      def Call.active_call_ids
        r = Skype.send_ :command => "SEARCH ACTIVECALLS"
        r.gsub(/CALLS /, "").split(", ")      
      end

      def Call.active_calls
        calls = Call.active_call_ids.collect { |id| Call.new id unless id == "COMMAND_PENDING"}
        calls
      end
    end

    # Creates a Call object from a call_id.
    def initialize(call_id)
      raise ArgumentError("Cannot pass nil call_id") if call_id.nil?
      @call_id = call_id
    end
  
    # Attempts to hang up a call. <b>Note</b>: If Skype hangs while placing the call, this method could hang indefinitely.
    # <u>Use Skype#Call instead of this method unless you like memory leaks</u>.  
    # Raises SkypeError if an error is reported from the Skype API
    def hangup
      s = Skype.send_ :command => "set call #{@call_id} status finished"
      raise SkypeError("Error occurred on hangup: #{s.message}") if s =~ /ERROR/
      s
    end
  
    # Retrieves the status of the current call.<br>
    # <b>Untested</b>
    def status
      Skype.send_ :command => "get call #{@call_id} status"
    end
  
    # Returns one of: VIDEO_NONE, VIDEO_SEND_ENABLED, VIDEO_RECV_ENABLED, VIDEO_BOTH_ENABLED
    def get_video_status
      Skype.send_ :command => "get call #{id} video_status"
    end
  
    # Accepts <i>:START</i> or <em>:STOP</em>
    def send_video(toggle_flag)
      raise Error.new("Illegal flag: #{toggle_flag}") if not @@TOGGLE_FLAGS.index toggle_flag
      Skype.send_ :command => "alter call #{id} #{toggle_flag.downcase.to_s}_video_send"
    end
  
    # Accepts <em>:START</em> or <em>:STOP</em>
    def rcv_video(toggle_flag)
      raise Error.new("Illegal flag: #{toggle_flag}") if not @@TOGGLE_FLAGS.index toggle_flag
      Skype.send_ :command => "alter call #{id} #{toggle_flag.downcase.to_s}_video_receive"
    end
    
    def <=>(call)
      @call_id <=> call.call_id
    end
  end
end