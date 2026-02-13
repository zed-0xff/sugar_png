# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sugar_png".freeze
  s.version = File.read(File.join(__dir__, "VERSION")).strip

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrey \"Zed\" Zaikin".freeze]
  s.email = "zed.0xff@gmail.com".freeze
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
  ]
  s.files = Dir.chdir(__dir__) do
    %w[Gemfile Gemfile.lock LICENSE.txt README.md VERSION sugar_png.gemspec] +
      Dir["lib/**/*.rb"] +
      Dir["data/font/??"]
  end
  s.homepage = "http://github.com/zed-0xff/sugar_png".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.32".freeze
  s.summary = "a syntax sugar of PNG manipulation".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  s.add_runtime_dependency("zpng", ">= 0.4.2")
  s.add_development_dependency("rspec", ">= 0")
  s.add_development_dependency("rspec-its", ">= 0")
  s.add_development_dependency("bundler", ">= 0")
  s.add_development_dependency("awesome_print", ">= 0")
end

