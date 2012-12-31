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

    def draw_borders borders
      xmin = 0
      xmax = self.width - 1
      ytop = 0
      ybtm = self.height - 1

      sumtop = borders.map(&:top).inject(&:+)
      sumbtm = borders.map(&:bottom).inject(&:+)

      borders.each do |b|
        b.top.times do
          xmin.upto(xmax){ |x| self[x,ytop] = b.color }
          ytop += 1
        end
        b.bottom.times do
          xmin.upto(xmax){ |x| self[x,ybtm] = b.color }
          ybtm -= 1
        end
        b.left.times do
          ytop.upto(sumtop){ |y| self[xmin, y] = b.color }
          ybtm.downto(height-sumbtm){ |y| self[xmin, y] = b.color }
          xmin += 1
        end
        b.right.times do
          ytop.upto(sumtop){ |y| self[xmax, y] = b.color }
          ybtm.downto(height-sumbtm){ |y| self[xmax, y] = b.color }
          xmax -= 1
        end
      end

      # copy remaining identical scanlines
      sl0 = scanlines[ytop]
      (ytop+1).upto(ybtm) do |y|
        scanlines[y].decoded_bytes = sl0.decoded_bytes.dup
      end
    end
  end
end
