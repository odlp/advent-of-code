# Usage: ruby solution.rb input.txt

positions = ARGF.read.split(",").map(&:to_i)

def find_min_fuel_cost(current_positions)
  potential_positions = Range.new(*current_positions.minmax)

  fuel_costs = potential_positions.map do |potential|
    current_positions.sum { |current| yield (current - potential).abs }
  end

  fuel_costs.min
end

puts "Part 1:", find_min_fuel_cost(positions) { |distance| distance }
puts "Part 2:", find_min_fuel_cost(positions) { |distance| (1..distance).sum }
