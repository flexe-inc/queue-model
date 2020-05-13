require "minitest/autorun"
require "./queue.rb"
require "./queue_bucket.rb"

describe BucketedQueue do

  describe "when empty" do
    before do
      @queue = BucketedQueue.new
    end

    describe "and the queue is stepped" do
      before do
        @queue.step
      end

      it "has no buckets" do
        @queue.current_buckets.keys.must_be_empty
      end
    end

    describe "and the queue egresses 1" do
      before do
        @removed = @queue.egress(1)
      end

      it "has no buckets" do
        @queue.current_buckets.keys.must_be_empty
      end

      it "returns nothing removed" do
        @removed.must_be_empty
      end
    end
  end

  describe "with buckets at 1, 2, and 5" do
    before do
      @queue = BucketedQueue.new({
                             1 => BucketedQueueBucket.new(10),
                             2 => BucketedQueueBucket.new(6),
                             5 => BucketedQueueBucket.new(2)
                         })
    end

    describe "and the queue is stepped" do
      before do
        @queue.step
      end

      it "has buckets at 2, 3, and 6" do
        @queue.bucket_keys.must_equal [2,3,6]
      end

      it "has 2 items in the 6 bucket" do
        @queue.current_buckets[6].current_quantity.must_equal 2
      end

      it "has 6 items in the 3 bucket" do
        @queue.current_buckets[3].current_quantity.must_equal 6
      end

      it "has 10 items in the 2 bucket" do
        @queue.current_buckets[2].current_quantity.must_equal 10
      end
    end

    describe "and the queue ingresses 1" do
      before do
        @queue.ingress(1)
      end

      it "has buckets at 0, 1, 2, and 5" do
        @queue.bucket_keys.must_equal [0,1,2,5]
      end

      it "has 1 items in the 0 bucket" do
        @queue.current_buckets[0].current_quantity.must_equal 1
      end

      it "has 10 items in the 1 bucket" do
        @queue.current_buckets[1].current_quantity.must_equal 10
      end

      it "has 6 items in the 2 bucket" do
        @queue.current_buckets[2].current_quantity.must_equal 6
      end

      it "has 2 items in the 5 bucket" do
        @queue.current_buckets[5].current_quantity.must_equal 2
      end
    end

    describe "and the queue egresses 1" do
      before do
        @removed = @queue.egress(1)
      end

      it "has buckets at 1, 2, and 5" do
        @queue.bucket_keys.must_equal [1,2,5]
      end

      it "has 10 items in the 1 bucket" do
        @queue.current_buckets[1].current_quantity.must_equal 10
      end

      it "has 6 items in the 2 bucket" do
        @queue.current_buckets[2].current_quantity.must_equal 6
      end

      it "has 1 items in the 5 bucket" do
        @queue.current_buckets[5].current_quantity.must_equal 1
      end

      it "returns what was removed" do
        @removed.must_equal ({5 => 1})
      end
    end

    describe "and the queue egresses 2" do
      before do
        @removed = @queue.egress(2)
      end

      it "has buckets at 1, 2" do
        @queue.bucket_keys.must_equal [1,2]
      end

      it "has 10 items in the 1 bucket" do
        @queue.current_buckets[1].current_quantity.must_equal 10
      end

      it "has 6 items in the 2 bucket" do
        @queue.current_buckets[2].current_quantity.must_equal 6
      end

      it "returns what was removed" do
        @removed.must_equal ({5 => 2})
      end
    end

    describe "and the queue egresses 3" do
      before do
        @removed = @queue.egress(3)
      end

      it "has buckets at 1, and 2" do
        @queue.bucket_keys.must_equal [1,2]
      end

      it "has 10 items in the 1 bucket" do
        @queue.current_buckets[1].current_quantity.must_equal 10
      end

      it "has 5 items in the 2 bucket" do
        @queue.current_buckets[2].current_quantity.must_equal 5
      end

      it "returns what was removed" do
        @removed.must_equal ({5 => 2, 2 => 1})
      end
    end

    describe "and the queue egresses enough to empty it" do
      before do
        @removed = @queue.egress(18)
      end

      it "has no buckets" do
        @queue.current_buckets.keys.must_be_empty
      end

      it "returns what was removed" do
        @removed.must_equal ({5 => 2, 2 => 6, 1 => 10})
      end
    end

    describe "and the queue egresses more than enough to empty it" do
      before do
        @removed = @queue.egress(200)
      end

      it "has no buckets" do
        @queue.current_buckets.keys.must_be_empty
      end

      it "returns what was removed" do
        @removed.must_equal ({5 => 2, 2 => 6, 1 => 10})
      end
    end
  end
end