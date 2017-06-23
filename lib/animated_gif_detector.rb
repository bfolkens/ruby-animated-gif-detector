require "animated_gif_detector/version"

class AnimatedGifDetector
  class UnrecognizedFileFormatException < Exception; end
  class EOFWithoutFrameException < Exception; end

  # http://www.matthewflickinger.com/lab/whatsinagif/animation_and_transparency.asp

  attr_reader :frames

  BLOCK_TERMINATOR = 0x00.chr
  GRAPHIC_CONTROL_EXTENSION_MAGIC = 0x21.chr + 0xF9.chr
  BLOCK_SIZE = (BLOCK_TERMINATOR + GRAPHIC_CONTROL_EXTENSION_MAGIC).size

  def initialize(io, options = {})
    @options = { buffer_size: 1024, terminate_after: true }.merge(options)
    @stream = io
    @frames = 0
  end

  def animated?
    return @animated if defined? @animated
    @animated = begin
      raise UnrecognizedFileFormatException unless @stream.read(3) == 'GIF'

      lookback = ''
      animated = false
      while data = @stream.read(@options[:buffer_size])
        @frames += count_substring_matches(lookback + data, BLOCK_TERMINATOR + GRAPHIC_CONTROL_EXTENSION_MAGIC)
        animated = @frames > 1

        if @options[:terminate_after] && animated
          @animated = true
          return true
        end

        lookback = last_characters(data, BLOCK_SIZE - 1)
      end

      raise EOFWithoutFrameException if @frames == 0
      animated
    end
  ensure
    @stream.rewind
  end

  private

  def count_substring_matches(str, match)
    last_pos = 0
    count = 0
    while pos = str.index(match, last_pos)
      count += 1
      last_pos = pos + match.length
    end

    count
  end

  def last_characters(str, n)
    str[-n..-1] || ''
  end
end
