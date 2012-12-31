require 'zpng'

require 'sugar_png/dyn_accessor'
require 'sugar_png/color'
require 'sugar_png/border'
require 'sugar_png/image'

class SugarPNG
  DEFAULT_BACKGROUND = :transparent

  Canvas = Datastream = Image

  class Exception < ::Exception; end
  class ArgumentError < Exception; end

  extend DynAccessor
  dyn_accessor :width, :height, :zoom
  dyn_accessor :bg => %w'background bg_color background_color'

  def initialize h={}, &block
    @bg   = DEFAULT_BACKGROUND
    @zoom = 1
    clear

    if block_given?
      if block.arity == 1
        yield self
      else
        instance_eval &block
      end
    end

    # boring non-magic hash
    h.each do |k,v|
      self.send "#{k}=", v
    end
  end

  # reset all drawings
  def clear
    @pixels  = Hash.new{ |k,v| k[v] = {} }
    @borders = []
  end

  # set pixels
  # accepted coordinate values:
  # a) boring Integers
  # b) neat   Arrays
  # c) long   Ranges
  # d) super  Enumerators
  #
  # accepted color values: see SugarPNG::Color
  def []= ax, ay, color
    Array(ay).each do |y|
      Array(ax).each do |x|
        @pixels[y][x] = color
      end
    end
  end

  %w'put_pixel set_pixel pixel point dot'.each do |x|
    # plural & singular aliases to increase entropy & prevent global singularity
    class_eval "alias :#{x} :[]=; alias :#{x}s :[]="
  end

  # draw image border with specified color
  def border size, color = nil
    color ||= @color || @bg
    @borders << Border.new( size.is_a?(Hash) ? size : {:size => size, :color => color} )
  end

  # same as border, but default color is background
  def padding size, color = @bg
    border size, color
  end

  # export PNG to file
  def save fname
    File.open(fname, "wb"){ |f| f<<to_s }
  end

  # get PNG as bytestream, for saving it to file manually, or for sending via HTTP
  def to_s
    height = @height || ((t=@pixels.keys.max) && t+1 ) || 0
    width = @width || ((t=@pixels.values.map(&:keys).map(&:max).max) && t+1 ) || 0

    xofs = yofs = 0
    xmax = width-1
    ymax = height-1

    if @borders.any?
      width  += @borders.map(&:width).inject(&:+)
      height += @borders.map(&:height).inject(&:+)
      xofs   += @borders.map(&:left).inject(&:+)
      yofs   += @borders.map(&:top).inject(&:+)
    end

    raise(Exception.new("invalid image height #{height}")) if height <= 0
    raise(Exception.new("invalid image width #{width}")) if width <= 0

    img = Image.new :width => width, :height => height, :depth => @depth
    img.clear(_color(@bg))     if @bg
    img.draw_borders(@borders.each{ |b| b.color = _color(b.color)} )

    @pixels.each do |y, xh|
      next if y>ymax
      xh.each do |x, c|
        next if x>xmax
        img[x+xofs,y+yofs] = _color(c)
      end
    end

    img.zoom(@zoom).export
  end

  private

  # create color from any of the supported color representations
  def _color c
    c = c.is_a?(ZPNG::Color) ? c : Color.new(c, :depth => @depth)
  end
end
