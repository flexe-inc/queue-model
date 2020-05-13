require 'csv'
require "./queue_simulation.rb"

file_name = "./datasets/sample-data.csv"
data = CSV.read(file_name).map { |d| d[0].to_i }
puts "Total increments #{data.count}"
qs = QueueSimulation.new(ingress_data: data)

puts "base rate"
pp qs.simulate


puts "base data x3 in"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 3)
pp qs.simulate

puts "base data x5 in"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 3)
pp qs.simulate

puts "base data x10"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 10)
pp qs.simulate



puts "base data x3 in, x4 out"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 3, egress_rate: 2000)
pp qs.simulate

puts "base data x5 in x4 out"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 3, egress_rate: 2000)
pp qs.simulate

puts "base data x10 in x4 out"
qs = QueueSimulation.new(ingress_data: data, ingress_multiplier: 10, egress_rate: 2000)
pp qs.simulate
