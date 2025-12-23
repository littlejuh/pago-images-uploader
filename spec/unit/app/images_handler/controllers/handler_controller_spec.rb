# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImagesHandler::HandlerController do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:image_service) { instance_double(ImagesHandler::ImageService) }

  before do
    allow_any_instance_of(described_class)
      .to receive(:image_service)
      .and_return(image_service)
  end

  describe 'POST /upload/image' do
    context 'when upload is successful' do
      let(:file) do
        Rack::Test::UploadedFile.new(
          fixture_path('test.png'),
          'image/png'
        )
      end

      before do
        allow(ImagesHandler::Image)
          .to receive(:allowed_mime_type?)
          .with(mime_type: 'image/png')
          .and_return(true)

        allow(image_service).to receive(:upload)
      end

      it 'returns 204 No Content' do
        post '/upload/image', image: file

        expect(last_response.status).to eq(204)
        expect(last_response.body).to be_empty
      end
    end

    context 'when file is missing' do
      it 'returns 400' do
        post '/upload/image'

        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('file missing')
      end
    end

    context 'when mime type is invalid' do
      let(:file) do
        Rack::Test::UploadedFile.new(
          fixture_path('test.txt'),
          'text/plain'
        )
      end

      before do
        allow(ImagesHandler::Image)
          .to receive(:allowed_mime_type?)
          .with(mime_type: 'text/plain')
          .and_return(false)
      end

      it 'returns 400' do
        post '/upload/image', image: file

        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('invalid type')
      end
    end
  end

  describe 'GET /static/image/:filename' do
    context 'when image exists' do
      let(:content) { 'binary-image-content' }

      before do
        allow(image_service)
          .to receive(:read)
          .with('image.png')
          .and_return(content)
      end

      it 'returns 200 and image content' do
        get '/static/image/image.png'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(content)
        expect(last_response.headers['Content-Type']).to include('image/png')
      end
    end

    context 'when image does not exist' do
      before do
        allow(image_service)
          .to receive(:read)
          .and_return(nil)
      end

      it 'returns 404' do
        get '/static/image/missing.png'

        expect(last_response.status).to eq(404)
      end
    end
  end
end
