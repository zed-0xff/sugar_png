require "zpng"
require "sugar_png/version"
require "sugar_png/dyn_accessor"
require 'sugar_png/color'
require 'sugar_png/border'
require 'sugar_png/image'
require 'sugar_png/font'
require 'sugar_png/glyph'

class SugarPNG
  DEFAULT_BG = :transparent
  DEFAULT_FG = :black

  Canvas = Datastream = Image

  class Exception < ::Exception; end
  class ArgumentError < Exception; end

  extend DynAccessor
  dyn_accessor :width, :height, :zoom, :depth
  dyn_accessor :bg => %w'background bg_color background_color'
  dyn_accessor :fg => %w'foreground fg_color foreground_color color'

  def initialize h={}, &block
    @bg   = DEFAULT_BG
    @fg   = DEFAULT_FG
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

  # same as above, but color argument can be optional
  def pixel ax, ay, color = @fg
    Array(ay).each do |y|
      Array(ax).each do |x|
        @pixels[y][x] = color
      end
    end
  end
  alias :pixels :pixel

  %w'put_pixel set_pixel point dot'.each do |x|
    # plural & singular aliases to increase entropy & prevent global singularity
    class_eval "alias :#{x} :pixel; alias :#{x}s :pixels"
  end

  # draw image border with specified color
  def border size, color = nil
    color ||= @fg || @bg
    @borders << Border.new( size.is_a?(Hash) ? size : {:size => size, :color => color} )
  end

  # same as border, but default color is background
  def padding size, color = @bg
    border size, color
  end

  # draw a single glyph, used from within text()
  def draw_glyph glyph, x0, y, color
    #TODO: optimize?
    glyph.to_a.each do |row|
      x = x0
      row.each do |bit|
        self[x,y] = color if bit == 1
        x += 1
      end
      y += 1
    end
  end

  # draws text, optional arguments are :color, :x, :y
  def text text, h = {}
    font  = @font ||= Font.new
    color = h[:color] || @fg
    y = h[:y] || 0
    text.split(/[\r\n]+/).each do |line|
      x = h[:x] || 0
      line.each_char do |c|
        glyph = font[c]
        draw_glyph glyph, x, y, color
        x += glyph.width
      end
      y += font.height
    end
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
  alias :export :to_s

  private

  # create color from any of the supported color representations
  def _color c
    c = c.is_a?(ZPNG::Color) ? c : Color.new(c, :depth => @depth)
  end
end
