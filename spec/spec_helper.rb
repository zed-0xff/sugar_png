$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rspec/its'
require 'sugar_png'
require 'awesome_print'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

SAMPLES_DIR = File.expand_path("../samples", File.dirname(__FILE__))

SAMPLES =
  if ENV['SAMPLES']
    ENV['SAMPLES'].split(' ')
  else
    Dir[File.join(SAMPLES_DIR,'qr_*.png')]
  end

PNGSuite.init( File.join(SAMPLES_DIR, "png_suite") )

def png_suite_file(kind, file)
  File.join(PNGSuite.dir, file)
end

def rgba_for fname
  dir = File.expand_path "../samples/rgba", File.dirname(__FILE__)
  unless Dir.exist?(dir)
    system "tar", "xjf", dir+".tar.bz2", "-C", File.dirname(dir)
  end
  File.join( dir, File.basename(fname, ".png")) + ".rgba"
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

  a = Dir[File.join(PNGSuite.dir, pattern)]
  a.keep_if{ |fname| File.fnmatch?(kind, File.basename(fname)) }
  puts "[?] png_suite_files: no files for #{[kind, pattern].inspect}".yellow if a.empty?
  a
end

module ResourceFileHelper
  def resource_file(name)
    File.expand_path("../samples/#{name}", File.dirname(__FILE__))
  end

  def resource_data(name)
    data = nil
    File.open(resource_file(name), 'rb') { |f| data = f.read }
    data
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
  config.extend  PNGSuite
  config.include PNGSuite
  config.include ResourceFileHelper
end
