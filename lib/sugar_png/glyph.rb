class SugarPNG
  class Glyph
    attr_accessor :width, :height, :data, :ord

    def initialize h = {}
      @ord    = h[:ord]
      @data   = h[:data]
      @width  = h[:width]
      @height = h[:height]
    end

    def blank?
      @data.tr("\x00","").empty?
    end

    def to_s repl=" #"
      bytes_in_row = (@width/8.0).ceil
      r = ''; ptr = 0
      @height.times.each do
        r += @data[ptr,bytes_in_row].unpack("B#@width")[0].tr("01",repl) + "\n"
        ptr += bytes_in_row
      end
      r.chomp
    end

    def to_a
      bytes_in_row = (@width/8.0).ceil
      r = []; ptr = 0
      @height.times.each do
        r << @data[ptr,bytes_in_row].unpack("B#@width")[0].split('').map(&:to_i)
        ptr += bytes_in_row
      end
      r
    end
  end
end
