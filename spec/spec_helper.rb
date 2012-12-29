$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'sugar_png'
require 'awesome_print'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module PNGSuite
  PNG_SUITE_URL = "http://www.schaik.com/pngsuite/PngSuite-2011apr25.tgz"
  PNG_SUITE_DIR = File.join(File.dirname(__FILE__), "png_suite")

  def self.download
    if Dir.exist?(dir = PNG_SUITE_DIR)
      if Dir[File.join(dir, "*.png")].size > 100
        # already fetched and unpacked
        return
      end
    else
      Dir.mkdir(dir)
    end
    require 'open-uri'
    puts "[.] fetching PNG test-suite from #{PNG_SUITE_URL} .. "
    data = open(PNG_SUITE_URL).read

    fname = File.join(dir, "png_suite.tgz")
    File.open(fname, "wb"){ |f| f<<data }
    puts "[.] unpacking .. "
    system "tar", "xzf", fname, "-C", dir
  end

  def png_suite_file(kind, file)
    File.join(PNG_SUITE_DIR, file)
  end

  def rgba_for fname
    File.join(File.expand_path(File.dirname(__FILE__)), "data", File.basename(fname, ".png")) + ".rgba"
  end

  def png_suite_files(kind, pattern = "*.png")
    kinds = {
      :broken       => "x*",
      :basic        => "bas*",
      :filtering    => "f*",
      :transparency => "t[bp]*",
      :sizes        => "s*"
    }
    kind = kinds[kind] || raise("unknown kind: #{kind}")

    a = Dir[File.join(PNG_SUITE_DIR, pattern)]
    a.keep_if{ |fname| File.fnmatch?(kind, File.basename(fname)) }
    puts "[?] png_suite_files: no files for #{[kind, pattern].inspect}".yellow if a.empty?
    a
  end
end

module ResourceFileHelper
  def resource_file(name)
    File.expand_path("./resources/#{name}", File.dirname(__FILE__))
  end

  def resource_data(name)
    data = nil
    File.open(resource_file(name), 'rb') { |f| data = f.read }
    data
  end
end

RSpec.configure do |config|
  config.extend  PNGSuite
  config.include PNGSuite
  config.include ResourceFileHelper
  config.before :suite do
    PNGSuite.download
  end
end
