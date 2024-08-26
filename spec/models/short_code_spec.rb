# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortCode do
  describe 'encode' do
    it 'encodes 0 to the first character in the alphabet' do
      expect(ShortCode.encode(0)).to eq('0')
    end

    it 'encodes a number correctly' do
      expect(ShortCode.encode(1)).to eq('1')
      expect(ShortCode.encode(61)).to eq('Z')
      expect(ShortCode.encode(62)).to eq('10')
      expect(ShortCode.encode(124)).to eq('20')
    end

    it 'encodes large numbers correctly' do
      expect(ShortCode.encode(123_456)).to eq('w7e')
      expect(ShortCode.encode(987_654_321)).to eq('14Q60p')
    end
  end

  describe 'decode' do
    it 'decodes a single character string correctly' do
      expect(ShortCode.decode('0')).to eq(0)
      expect(ShortCode.decode('Z')).to eq(61)
    end

    it 'decodes a string of multiple characters correctly' do
      expect(ShortCode.decode('10')).to eq(62)
      expect(ShortCode.decode('20')).to eq(124)
    end

    it 'decodes large strings correctly' do
      expect(ShortCode.decode('w7e')).to eq(123_456)
      expect(ShortCode.decode('14Q60p')).to eq(987_654_321)
    end

    it 'is the inverse of the encode method' do
      [0, 1, 61, 62, 123_456, 987_654_321].each do |num|
        encoded = ShortCode.encode(num)
        expect(ShortCode.decode(encoded)).to eq(num)
      end
    end
  end
end
