require "ocra"
require "releasy"
require "bundler/setup"
require_relative "lib/version"

Releasy::Project.new do
  name "War Of The Squares"
  version "#{VERSION}"

  executable "war_of_the_squares.rb"
  files ["lib/**/*.*"]
  exclude_encoding

  add_build :windows_folder do
    executable_type :windows
    add_package :exe
  end
end
