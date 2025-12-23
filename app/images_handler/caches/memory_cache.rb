# frozen_string_literal: true

module ImagesHandler
  class MemoryCache
    TTL = 60

    def initialize
      @store = {}
    end

    def fetch(key)
      entry = @store[key]
      return unless entry
      return if Time.now > entry[:expires_at]

      entry[:value]
    end

    def write(key, value)
      @store[key] = {
        value: value,
        expires_at: Time.now + TTL
      }
    end
  end
end
