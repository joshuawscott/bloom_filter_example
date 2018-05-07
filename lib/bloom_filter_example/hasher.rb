require 'murmurhash3'
module BloomFilterExample
  class Hasher
    # Runs a murmurhash multiple times with different seed values to return bit offsets to be set
    # in the bloom filter.

    def initialize(iterations, max)
      @iterations = iterations
      @hash_runs = (@iterations / 4.0).ceil
      @max = max
    end

    def hash(value)
      hashes = @hash_runs.times.map {|n|
        # This returns 4 32-bit integers.
        MurmurHash3::V128.str_hash(value, n).map {|h| h % @max}
      }.flatten.take(@iterations)
    end
  end
end
