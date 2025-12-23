# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe ImagesHandler::ImageService do
  let(:storage) { instance_double(ImagesHandler::LocalStorage) }
  let(:cache)   { instance_double(ImagesHandler::MemoryCache) }

  let(:service) do
    described_class.new(
      storage: storage,
      cache: cache
    )
  end

  describe '#upload' do
    let(:file_content) { 'image-binary-content' }
    let(:file)         { StringIO.new(file_content) }
    let(:filename)     { 'uuid.png' }

    before do
      allow(SecureRandom).to receive(:uuid).and_return('uuid')
      allow(cache).to receive(:write)
      allow(cache).to receive(:fetch).and_return(file_content)
      allow(storage).to receive(:save)
    end

    it 'writes file to cache' do
      service.upload(file)

      expect(cache)
        .to have_received(:write)
        .with(filename, file_content)
    end

    it 'persists file to storage using cached content' do
      service.upload(file)

      expect(storage)
        .to have_received(:save)
        .with(instance_of(StringIO), filename)
    end

    it 'returns generated filename' do
      result = service.upload(file)

      expect(result).to eq(filename)
    end
  end

  describe '#read' do
    let(:filename) { 'file.png' }
    let(:content)  { 'cached-content' }

    context 'when file is in cache' do
      before do
        allow(cache).to receive(:fetch).with(filename).and_return(content)
      end

      it 'returns cached content' do
        result = service.read(filename)

        expect(result).to eq(content)
      end

      it 'does not hit storage' do
        allow(storage).to receive(:exist?)

        service.read(filename)

        expect(storage).not_to have_received(:exist?)
      end
    end

    context 'when file is not cached but exists in storage' do
      before do
        allow(cache).to receive(:fetch).with(filename).and_return(nil)
        allow(storage).to receive(:exist?).with(filename).and_return(true)
        allow(storage).to receive(:read).with(filename).and_return(content)
        allow(cache).to receive(:write)
      end

      it 'reads from storage' do
        result = service.read(filename)

        expect(result).to eq(content)
      end

      it 'writes content to cache' do
        service.read(filename)

        expect(cache)
          .to have_received(:write)
          .with(filename, content)
      end
    end

    context 'when file does not exist' do
      before do
        allow(cache).to receive(:fetch).with(filename).and_return(nil)
        allow(storage).to receive(:exist?).with(filename).and_return(false)
      end

      it 'returns nil' do
        expect(service.read(filename)).to be_nil
      end
    end
  end
end
