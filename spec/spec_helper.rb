$LOAD_PATH.unshift('../lib', __FILE__)

require 'rspec'
require 'bestiary'
require 'nokogiri'

RSpec.configure do |config|
  config.order = 'random'
end
