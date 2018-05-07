require 'bitarray'
module BloomFilterExample
  class BloomFilter
    attr_reader :hasher

    def initialize(size, num_hashes)
      @hasher = Hasher.new(num_hashes, size)
      @bitarray = BitArray.new(size)
      @size = size
    end

    def exists?(item)
      bits_to_check = @hasher.hash(item)
      bits_to_check.all? {|bit| @bitarray[bit] == 1}
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

    def dump
      @bitarray
    end
  end
end
