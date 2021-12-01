# Usage: ruby solution.rb input.txt

depths = ARGF.readlines.map(&:to_i)

puts "Part 1:", depths.each_cons(2).count { |a, b| b > a }
puts "Part 2:", depths.each_cons(3).each_cons(2).count { |a, b| b.sum > a.sum }
