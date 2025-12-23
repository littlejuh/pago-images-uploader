# frozen_string_literal: true

module ImagesHandler
  class Image
    MAX_FILE_SIZE_IN_MB = 5
    BYTES_PER_MB = 1_024 * 1_024
    MAX_FILE_SIZE_IN_BYTES = MAX_FILE_SIZE_IN_MB * BYTES_PER_MB

    UPLOAD_DIRECTORY = File.expand_path('tmp/uploads', Dir.pwd)

    ALLOWED_MIME_TYPES = %w[
      image/png
      image/jpeg
      image/webp
    ].freeze

    ALLOWED_EXTENSIONS = %w[
      png jpg jpeg webp
    ].freeze

    def self.allowed_mime_type?(mime_type:)
      ALLOWED_MIME_TYPES.include?(mime_type)
    end

    def self.exceeds_max_size?(tempfile:)
      tempfile.size > MAX_FILE_SIZE_IN_BYTES
    end

    def self.valid_filename?(filename:)
  return false if filename.nil?
  return false if filename.include?('..')
  return false if filename.include?('/') || filename.include?('\\')

  extension = File.extname(filename).delete('.').downcase
  ALLOWED_EXTENSIONS.include?(extension)
end

    def self.file_path(filename:)
      File.join(UPLOAD_DIRECTORY, filename)
    end

    def self.file_exists?(filename:)
      File.exist?(file_path(filename: filename))
    end
  end
end
