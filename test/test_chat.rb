require File.dirname(__FILE__) + '/test_helper.rb'
include SkypeMac

class TestChat < Test::Unit::TestCase

  def setup
    @c = Chat.create 'echo123'
  end

  def test_recent_chats
    chats = Chat.recent_chats
    assert chats
    assert chats.class == Array
  end

  def test_chat_message
    responce = @c.chat_message 'test'
    assert responce.class == String
    assert !responce.empty?
  end
  
  def test_cmp
    chat = Chat.create 'echo123'
    assert @c == chat
  end
end
