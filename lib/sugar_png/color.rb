class SugarPNG
  class Color < ZPNG::Color
    class << self
      def a color
        color.a || (2**color.depth-1)
      end

      def r color; color.r; end
      def g color; color.g; end
      def b color; color.b; end
    end

    # accepted color values:
    # a) Strings:       "blue", "RED", ...
    # b) Symbols:       :blue, :red, ...
    # c) HTML notation: #cc3344, #ccc, ...
    # d) 3..4 int args: (10, 20, 30) - RGB; (0x20,0x30,0x40,0xff) - RGBA
    # e) Hexadecimals   0xaabbcc - RGB; 0x80aabbcc - RGBA
    # f) Hashes (long): { :red => 10, :green => 30, :blue => 40, :alpha => 0x80 }
    # g) Hashes (shrt): { r:10, g:20, b:30, a:50 } (alpha is optional)
    #
    # all notations also accept one optional last argument - hash:
    #   :depth => 1..16       - color depth of each channel, including alpha
    #   :alpha => 0..2^depth  - explicit definition of alpha value
    def initialize *args
      h = args.last.is_a?(Hash) ? args.pop : {}

      @depth = h.delete(:depth) || 8
      raise ArgumentError.new "invalid depth: #@depth" unless (1..16).include?(@depth)

      max = 2**@depth-1

      case args.size
      when 0        # single Hash that already in h
        # init colors to default values, we'll assign them later
        @r = @g = @b = 0
      when 1        # String(name or html), Symbol, Array, Integer, Hash
        case arg = args.first
        when String
          _from_string(arg)

        when Symbol
          _from_string(arg.to_s)

        when Array
          case arg.size
          when 3
            @r,@g,@b = arg
          when 4
            @r,@g,@b,@a = arg
          else
            raise ArgumentError.new "invalid array size: #{arg.size}, must be 3 or 4"
          end
        when Integer
          @r = (arg >> (@depth*2)) & max
          @g = (arg >> (@depth)) & max
          @b = arg & max
        when Hash
          # init colors to default values, we'll assign them later
          @r = @g = @b = 0
          h.merge! args.first
        else
          raise ArgumentError.new "invalid argument type: #{args.first.class}"
        end
      when 3        # r, g, b
        @r, @g, @b = args
      when 4        # r, g, b, a
        @r, @g, @b, @a = args
      else
        raise ArgumentError.new "invalid number of arguments: #{args.size}"
      end

      @a ||= max  # opaque by default

      h.each do |k,v|
        case k
        when :r, :red
          @r = v
        when :g, :green
          @g = v
        when :b, :blue
          @b = v
        when :a, :alpha
          @a = v
        else
          raise ArgumentError.new "invalid key: #{k}"
        end
      end

      [:r, :g, :b, :a].each do |x|
        v = self.send(x).to_i
        raise ArgumentError.new "invalid channel value: #{v}" if v<0 || v>max
      end
    end

    private

    # initialize self from string, either HTML color or simple color name
    # @depth must already be set!
    def _from_string s
      if s[0,1] == "#"
        # html colors #aabbcc or #abc
        case s.size
        when 4
          @r,@g,@b = s[1..-1].split('').map{ |x| x.to_i(16)*17 }
        when 7
          @r,@g,@b = s[1..-1].scan(/../).map{ |x| x.to_i(16) }
        else
          raise ArgumentError.new "invalid HTML color #{s}"
        end
      else
        @r, @g, @b, @a = self.class.const_get(s.strip.upcase).to_depth(@depth).to_a
      end
    rescue
      raise ArgumentError.new "invalid color name: #{s}"
    end
  end
end
