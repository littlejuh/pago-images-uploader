# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
ENV['SINATRA_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'fileutils'

require File.expand_path('../config/environment', __dir__)

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.after(:each) do
    FileUtils.rm_rf(Dir['tmp/uploads/*'])
  end
end

def app
  ImagesHandler::HandlerController
end

def fixture_path(filename)
  File.expand_path("fixtures/#{filename}", __dir__)
end
