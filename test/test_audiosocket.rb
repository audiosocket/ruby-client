require "isolate/now"
require "minitest/autorun"
require "audiosocket"

class TestAudiosocket < MiniTest::Unit::TestCase
  def test_self_config_defaults
    assert_equal "no-token-provided", Audiosocket[:token]
    assert_equal "http://audiosocket.com/api/v3", Audiosocket[:url]
  end
end
