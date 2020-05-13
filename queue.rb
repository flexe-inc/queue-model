class BucketedQueue
  attr_reader :current_buckets
  def initialize(buckets = {})
    @current_buckets = buckets
  end

  def amount_at(i)
    current_buckets[i] ? current_buckets[i].current_quanity : 0
  end

  def bucket_keys
    current_buckets.keys.sort
  end

  def ingress(amount)
    bucket_at(0).add(amount) if amount > 0
  end

  def egress(amount)
    remaining_to_remove = amount
    removed_quantities = {}

    while(remaining_to_remove > 0 && bucket_keys.count > 0) do
      last_bucket_key = current_buckets.keys.max

      last_bucket = bucket_at(last_bucket_key)
      num_removed = last_bucket.remove(remaining_to_remove)
      remaining_to_remove -= num_removed
      removed_quantities[last_bucket_key] = num_removed

      if last_bucket.current_quantity == 0
        current_buckets.delete(last_bucket_key)
      end
    end

    removed_quantities
  end

  def step
    new_buckets = {}
    current_buckets.each do |k,v|
      new_buckets[k+1] = v
    end

    @current_buckets = new_buckets
  end

  private

  def bucket_at(index)
    current_buckets[index] ||= QueueBucket.new
  end
end