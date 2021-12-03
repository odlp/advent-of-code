# Usage: ruby solution.rb input.txt

require "matrix"

input = ARGF.readlines.map { |line| line.chomp.chars.map(&:to_i) }

def part1(input)
  Matrix[*input]
    .column_vectors
    .map { |column| yield(column.tally) }
    .join
    .to_i(2)
end

def part2(input, tiebreaker:)
  haystack = input.dup
  index = 0

  until haystack.size <= 1
    tally = haystack.map { |row| row[index] }.tally
    tiebreak = tally.values.uniq.one?
    needle = tiebreak ? tiebreaker : yield(tally)

    haystack.select! { |row| row[index] == needle }
    index += 1
  end

  haystack.first.join.to_i(2)
end

most_common = ->(tally) { tally.key(tally.values.max) }
least_common = ->(tally) { tally.key(tally.values.min) }

gamma   = part1(input, &most_common)
epsilon = part1(input, &least_common)
puts "Part 1: gamma=#{gamma} epsilon=#{epsilon} answer=#{gamma * epsilon}"

oxygen = part2(input, tiebreaker: 1, &most_common)
co2    = part2(input, tiebreaker: 0, &least_common)
puts "Part 2: oxygen=#{oxygen} co2=#{co2} answer=#{oxygen * co2}"
