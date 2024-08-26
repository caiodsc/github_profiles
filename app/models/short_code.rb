# frozen_string_literal: false

module ShortCode
  ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
  BASE = ALPHABET.length
  ALPHABET_HASH = Hash[ALPHABET.chars.zip(0..BASE)]

  def self.encode(num = 0)
    return ALPHABET[num] if num.zero?

    result = ''

    while num.positive?
      result = (ALPHABET[num % BASE]) + result
      num /= BASE
    end

    result
  end

  def self.decode(str)
    number = 0

    str.reverse.each_char.with_index do |char, index|
      power = BASE**index
      index = ALPHABET_HASH[char]
      number += index * power
    end

    number
  end
end
