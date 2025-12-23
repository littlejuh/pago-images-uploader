# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ImagesHandler::MemoryCache do
  subject(:cache) { described_class.new }

  describe '#fetch' do
    context 'when key does not exist' do
      it 'returns nil' do
        expect(cache.fetch('missing')).to be_nil
      end
    end

    context 'when key exists and is not expired' do
      it 'returns the cached value' do
        cache.write('image_1', 'content')

        expect(cache.fetch('image_1')).to eq('content')
      end
    end

    context 'when key exists but is expired' do
      it 'returns nil' do
        cache.write('image_1', 'content')

        # força expiração
        store = cache.instance_variable_get(:@store)
        store['image_1'][:expires_at] = Time.now - 1

        expect(cache.fetch('image_1')).to be_nil
      end
    end
  end

  describe '#write' do
    it 'stores value with expiration time' do
      cache.write('image_1', 'content')

      store = cache.instance_variable_get(:@store)
      entry = store['image_1']

      expect(entry[:value]).to eq('content')
      expect(entry[:expires_at]).to be > Time.now
    end
  end
end
