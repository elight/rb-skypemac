require File.dirname(__FILE__) + '/test_helper.rb'
include SkypeMac

class TestGroup < Test::Unit::TestCase

  def setup
    @gs = Group.groups
  end

  def test_group_types
    gtypes = Group.types
    assert gtypes
    assert gtypes.class == Array
    assert !gtypes.empty?
  end

  def test_groups
    assert @gs
    assert @gs.class == Array
    assert !@gs.empty?
  end
  
  def test_get_type
    type = Group.get_type @gs[0].gid
    assert type
    assert type.class == String
    assert type.match(/^\w+$/)
  end
  
  def test_gtype
    assert @gs[0].gtype
    assert @gs[0].gtype.class == String
    assert @gs[0].gtype.match(/^\w+$/)
  end
  
  def test_gid
    assert @gs[0].gid
    assert @gs[0].gid.class == String
    assert @gs[0].gid.match(/^\d+$/)
  end
  
  def test_member_user_names
    user_names = @gs[0].member_user_names
    assert user_names
    assert user_names.class == Array
    assert !user_names.empty?
    user_names.each { |n| assert n.index(" ").nil? }
  end
  
  def test_users
    assert users = @gs[0].users
    assert users.empty? == false
    assert users[0].class == User
  end
end