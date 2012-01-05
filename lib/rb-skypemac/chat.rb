require 'rubygems'
require 'appscript'
include Appscript

module SkypeMac  

  class Chat
    attr_reader :chat_id
    
    class << self
      # create by user_handle
      def create(user_handle)
        r = Skype.send_ :command => "chat create #{user_handle}"
        chat_id = r.sub(/^CHAT\s+/, "").split(" ").first
        raise RuntimeError.new(r.to_s) if chat_id.empty?
        Chat.new chat_id
      end

      # Returns an array of your Skype recent chats
      def recent_chats
        r = Skype.send_ :command => "search recentchats"
        chat_ids = r.sub(/^CHATS\s+/, "").split(", ")
        chats = []
        chat_ids.each do |id|
          chats <<  Chat.new(id)
        end
        chats
      end
    end
  
    # chat message to chat
    def chat_message(message)
      r = Skype.send_ :command => "chatmessage #{@chat_id} #{message}"
      raise SkypeError("Error occurred on chat_message: #{r.message}") if r =~ /ERROR/
      r
    end
    
    def ==(chat)
      @chat_id == chat.chat_id
    end
    
    def initialize(chat_id)
      @chat_id = chat_id
    end
  end  
end
