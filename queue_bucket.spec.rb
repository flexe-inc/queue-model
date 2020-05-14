require "minitest/autorun"
require "./queue_bucket.rb"

describe QueueBucket do
  before do
    @bucket = QueueBucket.new
  end

  describe "when empty" do
    it "has 0" do
      @bucket.current_quantity.must_equal 0
    end

    describe "and something is added" do
      before do
        @bucket.add(3)
      end
      it "has that amount" do
        @bucket.current_quantity.must_equal 3
      end
    end

    describe "and something is subtracted" do
      before do
        @bucket.remove(3)
      end
      it "has 0" do
        @bucket.current_quantity.must_equal 0
      end
    end
  end

  describe "when not empty" do
    before do
      @bucket = QueueBucket.new(10)
    end

    describe "and something is added" do
      before do
        @bucket.add(3)
      end
      it "adds that amount" do
        @bucket.current_quantity.must_equal 13
      end
    end

    describe "and less than current quantity is removed" do
      before do
        @removed = @bucket.remove(3)
      end
      it "has the remainder" do
        @bucket.current_quantity.must_equal 7
      end

      it "returns the quantity that was removed" do
        @removed.must_equal 3
      end
    end

    describe "and exactly the current quantity is removed" do
      before do
        @removed = @bucket.remove(10)
      end

      it "is empty" do
        @bucket.current_quantity.must_equal 0
      end

      it "returns the quantity that was removed" do
        @removed.must_equal 10
      end
    end

    describe "and more the current quantity is removed" do
      before do
        @removed = @bucket.remove(12)
      end
      it "is empty" do
        @bucket.current_quantity.must_equal 0
      end

      it "returns the quantity that was removed" do
        @removed.must_equal 10
      end
    end
  end
end