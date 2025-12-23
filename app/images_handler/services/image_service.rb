# frozen_string_literal: true

module ImagesHandler
  class ImageService
    def initialize(
      storage: ImagesHandler::LocalStorage.new,
      cache: ImagesHandler::MemoryCache.new
    )
      @storage = storage
      @cache = cache
    end

    def upload(file)
      filename = "#{SecureRandom.uuid}.png"

      @cache.write(filename, file.read)

      # persiste async depois (por enquanto sync simples)
      @storage.save(StringIO.new(@cache.fetch(filename)), filename)

      filename
    end

    def read(filename)
      cached = @cache.fetch(filename)
      return cached if cached

      return unless @storage.exist?(filename)

      content = @storage.read(filename)
      @cache.write(filename, content)
      content
    end
  end
end
