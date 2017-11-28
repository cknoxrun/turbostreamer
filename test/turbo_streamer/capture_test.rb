require 'test_helper'

class TurboStreamer::CaptureTest < ActiveSupport::TestCase

  test "_capture" do
    old_buf_size = Wankel::DEFAULTS[:write_buffer_size]
    builder = TurboStreamer.new
    capture = nil

    begin
      Wankel::DEFAULTS[:write_buffer_size]  = 1_000_000

      builder.object! do
        builder.key1 'value1'
        capture = builder.__send__(:_capture) do
          builder.key2 'value2'
          builder.key4 'value4'
        end
        builder.key3 'value3'
      end
    ensure
      Wankel::DEFAULTS[:write_buffer_size] = old_buf_size
    end

    assert_equal '"key2":"value2","key4":"value4"', capture
    assert_equal '{"key1":"value1","key3":"value3"}', builder.target!
  end

end
