# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImagesHandler::Image do
  describe '.allowed_mime_type?' do
    it 'returns true for allowed mime types' do
      expect(described_class.allowed_mime_type?(mime_type: 'image/png')).to be true
      expect(described_class.allowed_mime_type?(mime_type: 'image/jpeg')).to be true
      expect(described_class.allowed_mime_type?(mime_type: 'image/webp')).to be true
    end

    it 'returns false for non allowed mime types' do
      expect(described_class.allowed_mime_type?(mime_type: 'text/plain')).to be false
      expect(described_class.allowed_mime_type?(mime_type: 'application/pdf')).to be false
    end
  end

  describe '.exceeds_max_size?' do
    let(:tempfile) { instance_double(Tempfile, size: size) }

    context 'when file size exceeds limit' do
      let(:size) { described_class::MAX_FILE_SIZE_IN_BYTES + 1 }

      it 'returns true' do
        expect(described_class.exceeds_max_size?(tempfile: tempfile)).to be true
      end
    end

    context 'when file size is within limit' do
      let(:size) { described_class::MAX_FILE_SIZE_IN_BYTES }

      it 'returns false' do
        expect(described_class.exceeds_max_size?(tempfile: tempfile)).to be false
      end
    end
  end

  describe '.valid_filename?' do
    it 'returns true for valid image filenames' do
      expect(described_class.valid_filename?(filename: 'image.png')).to be true
      expect(described_class.valid_filename?(filename: 'photo.jpeg')).to be true
      expect(described_class.valid_filename?(filename: 'file.webp')).to be true
    end

    it 'returns false for invalid extensions' do
      expect(described_class.valid_filename?(filename: 'file.txt')).to be false
      expect(described_class.valid_filename?(filename: 'file.exe')).to be false
    end

    it 'returns false when filename is nil' do
      expect(described_class.valid_filename?(filename: nil)).to be false
    end

    it 'returns false when filename contains path traversal' do
      expect(described_class.valid_filename?(filename: '../secret.png')).to be false
      expect(described_class.valid_filename?(filename: 'folder/evil.png')).to be false
    end
  end

  describe '.file_path' do
    it 'returns the full path for the file' do
      filename = 'test.png'
      expected_path = File.join(described_class::UPLOAD_DIRECTORY, filename)

      expect(described_class.file_path(filename: filename)).to eq(expected_path)
    end
  end

  describe '.file_exists?' do
    let(:filename) { 'existing.png' }

    before do
      allow(File).to receive(:exist?)
    end

    it 'returns true when file exists' do
      allow(File).to receive(:exist?).and_return(true)

      expect(described_class.file_exists?(filename: filename)).to be true
    end

    it 'returns false when file does not exist' do
      allow(File).to receive(:exist?).and_return(false)

      expect(described_class.file_exists?(filename: filename)).to be false
    end
  end
end
