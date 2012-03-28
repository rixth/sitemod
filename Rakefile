require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  require File.dirname(__FILE__) + '/spec/spec_helper'
  spec.pattern = FileList['spec/*.spec.rb']
end

desc "Build the extension"
task :build_extension do
  File.open("extension/sitemod.js", 'w+') do |f|
    f.write Tilt.new("extension/sitemod.coffee").render
  end
end

desc "Start the server"
task :start_server do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'sitemod'
  Sitemod::ModServer.run!
end