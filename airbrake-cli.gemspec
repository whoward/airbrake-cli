require File.expand_path("lib/airbrake_cli/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
   s.name = "airbrake-cli"
   s.version = AirbrakeCli::Version::STRING
   s.platform = Gem::Platform::RUBY

  s.authors = ["William Howard"]
  s.email = %q{whoward.tke@gmail.com}
  s.homepage = %q{http://github.com/whoward/airbrake-cli}

  s.default_executable = %q{airbrake}
  s.executables = ["airbrake"]

  s.require_paths = ["lib"]

  s.summary = %q{ruby command line tool for interacting with the Airbrake API}

  s.files = Dir.glob("lib/**/*.rb") + %w(Gemfile Gemfile.lock bin/airbrake)

  s.add_dependency "airbrake-api", "~> 4.1.1"
  s.add_dependency "thor", ">= 0.16.0"
  s.add_dependency "multi_json", ">= 1.3.6"
end
