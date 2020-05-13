# Represents a bucket of items at the same priority in a queue
class QueueBucket
  attr_reader :current_quantity
  def initialize(quantity = 0)
    @current_quantity = quantity
  end

  def add(quantity)
    @current_quantity += quantity
  end

  # Removes quantity from the bucket, returning the amount that was removed
  def remove(quantity)
    quantity_to_remove = [quantity, current_quantity].min
    @current_quantity = current_quantity - quantity_to_remove
    
    quantity_to_remove
  end
end