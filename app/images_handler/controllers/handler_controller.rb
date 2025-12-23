# frozen_string_literal: true

module ImagesHandler
  class HandlerController < Sinatra::Base
    helpers do
      def image_service
        @image_service ||= ImagesHandler::ImageService.new
      end
    end

    post '/upload/image' do
      file = params[:image]

      halt 400, 'file missing' unless file
      halt 400, 'invalid type' unless ImagesHandler::Image.allowed_mime_type?(mime_type: file[:type])

      image_service.upload(file[:tempfile])

      status 204
    end

    get '/static/image/:filename' do
      content = image_service.read(params[:filename])

      halt 404 unless content

      content_type 'image/png'
      status 200
      body content
    end
  end
end
