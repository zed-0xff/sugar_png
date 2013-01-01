class SugarPNG
  class Font
    DEFAULT_DIR = File.expand_path("../../data/font", File.dirname(__FILE__))
    HEIGHT = 16

    def initialize dir = DEFAULT_DIR
      @dir   = dir
      @pages = {}
    end

    def height
      HEIGHT
    end

    # get glyph by index
    def [] idx
      idx = idx.ord if !idx.is_a?(Integer) && idx.respond_to?(:ord)
      raise ArgumentError.new("invalid idx type: #{idx.class}") unless idx.is_a?(Integer)
      raise ArgumentError.new("invalid idx: #{idx.inspect}") if idx<0 || idx>0xffff

      pageno = idx >> 8
      @pages[pageno] ||= Page.new(File.join(@dir, "%02x" % pageno))
      @pages[pageno][idx]
    end

    class Page
      def initialize fname
        @data   = Marshal.load(File.binread(fname))
        @glyphs = {}
      end

      # get glyph by index
      def [] ord
        idx = ord&0xff
        @glyphs[idx] ||= Glyph.new(
          :height => HEIGHT,
          :width  => @data[idx].size/2,
          :data   => @data[idx],
          :ord    => ord
        )
      end
    end # class Page
  end # class Font
end
