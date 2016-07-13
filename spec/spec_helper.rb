$LOAD_PATH.unshift('../lib', __FILE__)

require 'rspec'
require 'bestiary'
require 'nokogiri'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

RSpec.configure do |config|
  config.order = 'random'
  config.include Helpers
end
