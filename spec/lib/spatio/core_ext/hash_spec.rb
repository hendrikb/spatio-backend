require 'spec_helper'

describe Hash do
  context 'same_keys?' do
    it 'is true for empty hashes' do
      {}.same_keys?({}).should be true
    end

    it 'is false with differnt keys' do
      hash = { a: 1 }
      other_hash = { b: 1 }
      hash.same_keys?(other_hash).should be false
    end

    it 'is true with different order of keys' do
      hash = { a: 1, b: 1 }
      other_hash = { b: 1, a: 1 }
      hash.same_keys?(other_hash).should be true
    end
  end
end
