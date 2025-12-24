# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImagesHandler::HandlerController do
  include Rack::Test::Methods

  def app
    ImagesHandler::HandlerController.new
  end

  def uploaded_file(content:, filename:, type:)
    tempfile = StringIO.new(content)
    Rack::Test::UploadedFile.new(tempfile, type, original_filename: filename)
  end

  subject(:request) { post '/upload/image', params }

  context 'POST /upload/image' do
    context 'when upload is successful' do
      let(:params) do
        { image: uploaded_file(content: 'fake image content', filename: 'test.png', type: 'image/png') }
      end

      it 'returns 204' do
        request
        expect(last_response.status).to eq(204)
      end
    end

    context 'when file is missing' do
      let(:params) { {} }

      it 'returns 400' do
        request
        expect(last_response.status).to eq(400)
      end
    end

    context 'when mime type is invalid' do
      let(:params) do
        { image: uploaded_file(content: 'fake text content', filename: 'test.txt', type: 'application/octet-stream') }
      end

      it 'returns 400' do
        request
        expect(last_response.status).to eq(400)
      end
    end

    context 'when image param is malformed' do
      let(:params) { { image: {} } }

      it 'returns 400' do
        request
        expect(last_response.status).to eq(400)
      end
    end
  end
end
