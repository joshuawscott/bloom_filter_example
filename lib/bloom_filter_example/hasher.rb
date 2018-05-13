require 'murmurhash3'
module BloomFilterExample
  # Runs a murmurhash multiple times with different seed values to return bit offsets to be set
  # in the bloom filter.
  class Hasher
    def initialize(iterations, max)
      @iterations = iterations
      @max = max
    end

    def hash(value)
      Array.new(@iterations) { |n| MurmurHash3::V32.str_hash(value, n) % @max }
    end
  end
end
