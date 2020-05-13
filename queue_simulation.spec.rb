require "minitest/autorun"
require "./queue_simulation.rb"

describe QueueSimulation do

  describe "with an initial burst and constant 20% egress" do
    before do
      @simulation = QueueSimulation.new(ingress_data: [100, 0, 0, 0, 0], egress_rate: 20)
    end

    it "has a max wait time of 4" do
      @simulation.simulate[:max].must_equal(4)
    end
  end

  describe "with a a ramp and level off" do
    before do
      @simulation = QueueSimulation.new(
          ingress_data: [5, 10, 20, 50, 20, 10, 5, 5],
          egress_rate: 10
      )
    end

    it "has a max wait time of 4" do
      @simulation.simulate[:max].must_equal(4)
    end
  end

  describe "when it never clears the originals" do
    before do
      @simulation = QueueSimulation.new(
          ingress_data: [1000, 0, 0, 0, 0, 0, 0, 0], #8 entries = max wait 7
          egress_rate: 10
      )
    end

    it "has a max wait time equal to total time" do
      @simulation.simulate[:max].must_equal(7)
    end
  end
end