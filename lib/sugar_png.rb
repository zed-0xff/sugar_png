require 'zpng'

require 'sugar_png/image'
require 'sugar_png/color'
require 'sugar_png/dyn_accessor'

class SugarPNG
  DEFAULT_BACKGROUND = :transparent

  Canvas = Datastream = Image

  class Exception < ::Exception; end
  class ArgumentError < Exception; end

  extend DynAccessor
  dyn_accessor :width, :height
  dyn_accessor :bg => %w'background bg_color background_color'

  def initialize h={}, &block
    @bg = DEFAULT_BACKGROUND
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

  # reset all drawings
  def clear
    @pixels = Hash.new{ |k,v| k[v] = {} }
  end

  # export PNG to file
  def save fname
    File.open(fname, "wb"){ |f| f<<to_s }
  end

  # get PNG as bytestream, for saving it to file manually, or for sending via HTTP
  def to_s
    height = @height || ((t=@pixels.keys.max) && t+1 ) ||
      raise(Exception.new("NULL image height"))
    width = @width || ((t=@pixels.values.map(&:keys).map(&:max).max) && t+1 ) ||
      raise(Exception.new("NULL image width"))

    img = Image.new :width => width, :height => height
    img.clear(_color(@bg)) if @bg

    @pixels.each do |y, xh|
      xh.each do |x, c|
        img[x,y] = _color(c)
      end
    end
    img.export
  end

  private

  # create color from any of the supported color representations
  def _color c
    c = c.is_a?(Color) ? c : Color.new(c, :depth => @depth)
  end
end
