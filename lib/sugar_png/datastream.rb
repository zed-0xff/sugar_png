module SugarPNG
  class Datastream
    attr_accessor :img

    def initialize h={}
      @img = h[:img]
    end

    def metadata
      {}
    end

    class << self
      def from_file fname
        self.new :img => ZPNG::Image.load(fname)
      end
    end
  end
end
