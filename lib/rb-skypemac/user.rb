require 'rubygems'
require 'appscript'
include Appscript

module SkypeMac  

  # Represents Skype internal grouping of contacts; https://developer.skype.com/Docs/ApiDoc/GROUP_object
  class User
    class << self
      def skype_attr(attr_sym, accessor=false)
        module_eval %{def #{attr_sym.to_s}
          r = Skype.send_ :command => "get user \#{@handle} #{attr_sym.to_s}"
          v = r.sub(/^.*#{attr_sym.to_s.upcase} /, "")
          v = true if v == "TRUE"
          v = false if v == "FALSE"
          v
        end}
        if accessor
          module_eval %{def #{attr_sym.to_s}=(value)
            value = "true" if value == true
            value = "False" if value == false
            r = Skype.send_ :command => "set user \#{@handle} #{attr_sym.to_s} \#{value}"
            v = r.sub(/^.*#{attr_sym.to_s.upcase} /, "")
            v = true if v == "TRUE"
            v = false if v == "FALSE"
            v
          end}
        end
      end

      def skype_attr_reader(*attr_sym)
        attr_sym.each do |a|
          User.skype_attr a, false
        end
      end
    
      def User.skype_attr_accessor(*attr_sym)
        attr_sym.each do |a|
          User.skype_attr a, true
        end
      end
    end

    attr_reader :handle
    skype_attr_reader :fullname, :birthday, :sex, :language, :country, :province
    skype_attr_reader :city, :phone_home, :phone_office, :phone_mobile, :homepage
    skype_attr_reader :about, :is_video_capable, :is_authorized
    skype_attr_reader :onlinestatus, :skypeout, :lastonlinetimestamp
    skype_attr_reader :can_leave_vm, :receivedauthrequest, :mood_text
    skype_attr_reader :rich_mood_text, :is_cf_active, :nrof_authed_buddies
    
    #TODO: attr_reader :aliases, :timezone
    
    skype_attr_accessor :buddystatus, :isblocked, :isauthorized, :speeddial, :displayname

    def initialize(handle)
      @handle = handle
    end
    
    def name
      if displayname != "": displayname
      elsif fullname != "": fullname
      else handle
      end
    end
    
    def <=>(user)
      name.upcase <=> user.name.upcase
    end
  end
end