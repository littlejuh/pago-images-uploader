# frozen_string_literal: true

module ImagesHandler
  class LocalStorage < Storage
    UPLOAD_DIR = File.expand_path('tmp/uploads', Dir.pwd)

    def initialize
      super
      FileUtils.mkdir_p(UPLOAD_DIR)
    end

    def save(file, filename)
      path = File.join(UPLOAD_DIR, filename)
      File.write(path, file.read)
      path
    end

    def read(filename)
      File.read(file_path(filename))
    end

    def exist?(filename)
      File.exist?(file_path(filename))
    end

    def file_path(filename)
      File.join(UPLOAD_DIR, filename)
    end
  end
end
