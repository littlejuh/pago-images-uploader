# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require './app/images_handler/validators/image'
require './app/images_handler/caches/memory_cache'
require './app/images_handler/storages/storage'
require './app/images_handler/storages/local_storage'
require './app/images_handler/services/image_service'
require './app/images_handler/controllers/handler_controller'
