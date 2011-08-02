require File.dirname(__FILE__) + '/test_helper.rb'
include SkypeMac

class TestCall< Test::Unit::TestCase

  def test_new
    assert Call.new(42)
  end
  
  def test_active_call_ids
    assert call_ids = Call.active_call_ids
    assert call_ids.empty?
  end
  
  def test_active_calls
    assert calls = Call.active_calls
    assert calls.empty?
  end
end