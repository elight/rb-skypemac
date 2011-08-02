require File.dirname(__FILE__) + '/test_helper.rb'


class TestSkype < Test::Unit::TestCase

  def test_groups
    gs = Skype.groups
  end

  def test_online_friends
    assert users = Skype.online_friends
    assert users.empty? == false
    assert users[0].class == User
  end
  
  def test_incoming_calls
    assert inc = Skype.incoming_calls
    assert inc.empty?
  end  
end