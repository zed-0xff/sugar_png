class SugarPNG
  class Image < ZPNG::Image
    def to_rgba_stream
      pixels.map do |color|
        color.to_depth(8).to_a.pack('C*')
      end.join
    end

    def clear color
      width.times do |x|
        self[x,0] = color
      end
      sl0 = scanlines[0]
      scanlines[1..-1].each do |sl|
        sl.decoded_bytes = sl0.decoded_bytes.dup
      end
    end
  end
end
