# frozen_string_literal: true

# Define o ambiente
ENV['SINATRA_ENV'] ||= 'development'

# Carrega bundler
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# --- Carrega arquivos do app ---
# Validators
require './app/images_handler/validators/image'

# Caches
require './app/images_handler/caches/memory_cache'

# Storages
require './app/images_handler/storages/storage'
require './app/images_handler/storages/local_storage'

# Services
require './app/images_handler/services/image_service'

# Controllers
require './app/images_handler/controllers/handler_controller'
