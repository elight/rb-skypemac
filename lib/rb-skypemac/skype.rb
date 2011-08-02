require 'rubygems'
require 'appscript'
include Appscript

module SkypeMac

  # Singleton for interfacing with Skype
  class Skype
    @@groups = nil
    @@calls = []

    class << self
      # The Appscript interface to Skype.  Requires a Hash containing:
      # (1) <i>:command</i> - the Skype API command to pass,
      # (2) <i>:script_name</i> - unknown all though an empty String makes Skype happy.
      # Impl adds <i>:script_name</i> to Hash and warns if it is not provided
      def send_(params)
        params[:script_name] = "" if not params.has_key? :script_name
        app('Skype').send_ params
      end

      # Initiates a Skype call
  	  def call(*person)
        user_handles = person.collect { |u| (u.is_a? User) ? u.handle : u }
        status = Skype.send_ :command => "call #{user_handles.join(', ')}"
        if status =~ /CALL (\d+) STATUS/
          @@calls << call = Call.new($1)
        else
          raise RuntimeError.new("Call failed. Skype returned '#{status}'")
        end
        call
      end

      # Returns an Array of Call IDs if there is an incoming Skype call otherwise nil
      def incoming_calls
        calls = Call.active_calls - @@calls
        calls
      end

      # Answers a call given a skype Call ID.  Returns an Array of Call objects.
      def answer(call)
        cmd = "ALTER CALL #{call.call_id} ANSWER"
        r = Skype.send_ :command => cmd
        raise RuntimeError("Failed to answer call.  Skype returned '#{r}'") unless r == cmd
        @@calls << call
      end


      # Use this method to disconnect from a Call whether it was answered or iniiated locally.
      # Raises SkypeError if an error is reported from the Skype API
      def hangup(call)
        @@calls.delete call if call.hangup
      end

      # Returns an Array of Group
      def groups
        @@groups = Group.groups if @@groups.nil? or @@groups.empty?
        @@groups
      end

      # Returns Array of all User in a particular Group type.  Accepts types as defined by Group.types
      def find_users_of_type(group_type)
        begin
          Skype.groups.find { |g| g.gtype == group_type}.users
        rescue Exception => e
          puts e.message
        end
      end

      # Returns an array of users online friends as User objects
      def online_friends
        Skype.find_users_of_type "ONLINE_FRIENDS"
      end

      # Array of all User that are friends of the current user
      def all_friends
        Skype.find_users_of_type "ALL_FRIENDS"
      end

      # Array of all User defined as Skype Out users
      def skypeout_friends
        Skype.find_users_of_type "SKYPEOUT_FRIENDS"
      end

      # Array of all User that the user knows
      def all_users
        Skype.find_users_of_type "ALL_USERS"
      end

      # Array of User recently contacted by the user, friends or not
      def recently_contacted_users
        Skype.find_users_of_type "RECENTLY_CONTACTED_USERS"
      end

      # Array of User waiting for authorization
      def users_waiting_for_authorization
        Skype.find_users_of_type "USERS_WAITING_MY_AUTHORIZATION"
      end

      # Array of User blocked
      def blocked_users
        Skype.find_users_of_type "USERS_BLOCKED_BY_ME"
      end

      # Minimize the Skype window
      def minimize
        Skype.send_ :command => "MINIMIZE"
      end
    end
  end
end
