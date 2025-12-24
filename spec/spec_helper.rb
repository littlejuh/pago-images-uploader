# frozen_string_literal: true

require 'rspec'
require 'rack/test'

# Define ambiente de teste
ENV['SINATRA_ENV'] ||= 'test'

# Carrega todas as dependências do app
require_relative '../config/environment'

# Configurações globais do RSpec
RSpec.configure do |config|
  # Permite usar let/subject/etc sem warnings
  config.expose_dsl_globally = true

  # Syntax moderna
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Ordem aleatória
  config.order = :random

  # Limpeza antes de cada teste (caso queira resetar caches ou storage)
  config.before(:each) do
    # Exemplo: limpar uploads temporários
    FileUtils.rm_rf(ImagesHandler::LocalStorage::UPLOAD_DIR) if defined?(ImagesHandler::LocalStorage)
  end
end
