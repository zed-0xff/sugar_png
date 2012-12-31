class SugarPNG
  class Border
    attr_accessor :left, :right, :top, :bottom, :color
    def initialize h
      @color = h[:color] || raise(ArgumentError.new("border color must be set"))
      @left  = (h[:left]  || h[:size]).to_i
      @right = (h[:right] || h[:size]).to_i
      @top   = (h[:top]   || h[:size]).to_i
      @bottom= (h[:bottom]|| h[:size]).to_i
    end

    def width
      @left + @right
    end

    def height
      @top + @bottom
    end
  end
end
