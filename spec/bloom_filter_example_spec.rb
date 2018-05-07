RSpec.describe BloomFilterExample do
  it "has a version number" do
    expect(BloomFilterExample::VERSION).not_to be nil
  end

  it "detects duplicates" do
    bf = BloomFilterExample::BloomFilter.new(65_536, 16)
    bf.add("foo")
    expect(bf.exists?("foo")).to be true
    expect(bf.exists?("bar")).to be false
  end

  it "has collisions" do
    bf = BloomFilterExample::BloomFilter.new(8, 8)
    # Verify that we have a hash collision
    expect(bf.hasher.hash("22").sort).to eq bf.hasher.hash("1276").sort

    bf.add("22")

    expect(bf.exists?("1276")).to be true
  end

  it "has an expected error rate" do
    # 20 m/n vs k=2 = error rate of about 0.00906 or 906 expected false positives in 100K checks.
    bf = BloomFilterExample::BloomFilter.new(20, 2)
    bf.add("foo")
    collisions = 100_000.times.select { |n| bf.exists?(n.to_s) }.length
    expect(collisions).to be < 1100
  end
end
