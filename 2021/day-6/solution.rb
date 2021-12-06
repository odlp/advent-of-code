# Usage: ruby solution.rb input.txt

CYCLE_START = 6
FIRST_CYCLE_START = 8

def advance(days:, shoal:)
  1.upto(days) do
    next_gen = Hash.new(0)

    shoal.each do |lifecycle, count|
      if lifecycle > 0
        next_gen[lifecycle - 1] += count
      else
        next_gen[CYCLE_START] += count
        next_gen[FIRST_CYCLE_START] += count
      end
    end

    shoal = next_gen
  end

  shoal.values.sum
end

shoal = ARGF.read.split(",").map(&:to_i).tally
puts "Part 1:", advance(days: 80,  shoal: shoal)
puts "Part 2:", advance(days: 256, shoal: shoal)
