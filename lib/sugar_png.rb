require 'zpng'

SugarPNG = ZPNG

module SugarPNG
  class Color
    class << self
      def a color
        color.a || (2**color.depth-1)
      end
    end
  end
end

require 'sugar_png/datastream'
require 'sugar_png/canvas'
