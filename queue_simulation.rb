# Takes a dataset of baseline ingress quantities per time increment (i.e. 1 minute, obtained with TIMESTAMP_TRUNC(date, MINUTE) from BigQuery)
# Takes a volume multiplier for that data
# Takes an egress rate per time increment, i.e. 500/minute
# Calculates the maximum and average number of increments something spends in queue before being processed
#
#
require "./queue_bucket.rb"
require "./queue.rb"

class QueueSimulation
  attr_reader :lifetimes
  def initialize(ingress_data:, ingress_multiplier: 1, egress_rate: 500)
    @ingress_data = ingress_data
    @ingress_multiplier = ingress_multiplier
    @egress_rate = egress_rate
    @lifetimes = []
  end

  # Ingress(time) function is based on sampled dataset
  def ingress(time_increment)
    @ingress_data[time_increment] * @ingress_multiplier
  end

  def time_increments
    @ingress_data.count
  end

  # Egress(time) is constant
  def egress(_time_increment)
    @egress_rate
  end

  def simulate
    queue = BucketedQueue.new
    time_increments.times do |time_increment|
      ingress_amount = ingress(time_increment)
      egress_amount = egress(time_increment)
      queue.ingress(ingress_amount)
      @lifetimes << queue.egress(egress_amount)
      queue.step
    end
    # NB: there could still be data left in the queue

    max = 0
    @lifetimes.each do |lifetime_set|
      lifetime_max = lifetime_set.keys.max || 0
      max = [max, lifetime_max].max
    end
    {
        max: max
    }
  end
end