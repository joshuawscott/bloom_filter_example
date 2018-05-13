require 'bitarray'
module BloomFilterExample
  # A Bloom filter.
  class BloomFilter
    attr_reader :hasher
    attr_reader :num_hashes, :size, :error_rate, :capacity

    def initialize(capacity, error_rate)
      @capacity = capacity
      @error_rate = error_rate
      @size = calculate_bits
      @num_hashes = calculate_hashes

      @hasher = Hasher.new(@num_hashes, @size)
      @bitarray = BitArray.new(@size)
    end

    def exists?(item)
      bits_to_check = @hasher.hash(item)
      bits_to_check.all? { |bit| @bitarray[bit] == 1 }
    end

    def add(item)
      bits_to_set = @hasher.hash(item)
      bits_to_set.map do |bit|
        if @bitarray[bit] == 1
          false
        else
          @bitarray[bit] = 1
          true
        end
      end.any?
    end

    def calculate_bits
      -((@capacity * Math.log(@error_rate)) / (Math.log(2)**2)).round
    end

    def calculate_hashes
      ((@size / @capacity.to_f) * Math.log(2)).round
    end

    def dump
      @bitarray
    end
  end
end
