# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe ImagesHandler::LocalStorage do
  subject(:storage) { described_class.new }

  let(:filename) { 'test-file.txt' }
  let(:content)  { 'hello world' }
  let(:file)     { StringIO.new(content) }
  let(:full_path) { File.join(described_class::UPLOAD_DIR, filename) }

  after do
    FileUtils.rm_rf(described_class::UPLOAD_DIR)
  end

  describe '#save' do
    it 'saves the file to disk and returns the path' do
      path = storage.save(file, filename)

      expect(path).to eq(full_path)
      expect(File.exist?(full_path)).to be(true)
      expect(File.read(full_path)).to eq(content)
    end
  end

  describe '#read' do
    before do
      storage.save(StringIO.new(content), filename)
    end

    it 'reads the file content from disk' do
      result = storage.read(filename)

      expect(result).to eq(content)
    end
  end

  describe '#exist?' do
    context 'when file exists' do
      before do
        storage.save(StringIO.new(content), filename)
      end

      it 'returns true' do
        expect(storage.exist?(filename)).to be(true)
      end
    end

    context 'when file does not exist' do
      it 'returns false' do
        expect(storage.exist?(filename)).to be(false)
      end
    end
  end

  describe '#file_path' do
    it 'returns the correct absolute file path' do
      expect(storage.file_path(filename)).to eq(full_path)
    end
  end
end
