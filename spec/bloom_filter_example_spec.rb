RSpec.describe BloomFilterExample do
  it "has a version number" do
    expect(BloomFilterExample::VERSION).not_to be nil
  end

  it "calculates the optimal number of hashes and bits" do
    bf = BloomFilterExample::BloomFilter.new(100_000, 0.01)
    expect(bf.num_hashes).to eq 7
    expect(bf.size).to eq 958_506
  end

  it "detects duplicates" do
    bf = BloomFilterExample::BloomFilter.new(2, 0.01)
    bf.add("foo")
    expect(bf.exists?("foo")).to be true
    expect(bf.exists?("bar")).to be false
  end

  it "has collisions" do
    bf = BloomFilterExample::BloomFilter.new(1, 0.5)
    # Verify that we have a hash collision
    expect(bf.hasher.hash("22").sort).to eq bf.hasher.hash("1276").sort

    bf.add("22")

    expect(bf.exists?("1276")).to be true
  end

  it "has an expected error rate" do
    bf = BloomFilterExample::BloomFilter.new(100_000, 0.01)
    bf.add("foo")
    collisions = 100_000.times.select { |n| bf.exists?(n.to_s) }.length
    expect(collisions).to be < 1100
  end
end
