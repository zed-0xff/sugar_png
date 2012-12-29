module SugarPNG
  class Canvas < ZPNG::Image
    def to_rgba_stream
      pixels.map do |color|
        color.to_depth(8).to_a.pack('C*')
      end.join
    end
  end
end
