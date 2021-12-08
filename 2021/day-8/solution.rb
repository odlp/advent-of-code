# Usage: ruby solution.rb input.txt

require "set"

# 0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
# ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
#
# 5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

class OutputPatternMapper
  def initialize(patterns:, outputs:)
    @patterns = patterns
    @outputs = outputs
    @mapping = {}
  end

  def solve
    determine_mapping
    outputs.map { |output| mapping.key(output) }.join.to_i
  end

  private

  attr_reader :patterns, :outputs, :mapping

  def determine_mapping
    # Distinct segment-count digits
    map_value(1) { |pat| pat.size == 2 }
    map_value(4) { |pat| pat.size == 4 }
    map_value(7) { |pat| pat.size == 3 }
    map_value(8) { |pat| pat.size == 7 }

    # Six-segment digits
    map_value(6) { |pat| pat.size == 6 && (pat + mapping[1]) == mapping[8] }
    map_value(0) { |pat| pat.size == 6 && (pat + mapping[4]) == mapping[8] }
    map_value(9) { |pat| pat.size == 6 }

    # Five-segment digits
    map_value(5) { |pat| pat.size == 5 && (pat - mapping[6]).size == 0 }
    map_value(2) { |pat| pat.size == 5 && (pat - mapping[7]).size == 3 }
    map_value(3) { |pat| pat.size == 5 }
  end

  def map_value(value)
    pattern = unsolved.detect { |pattern| yield(pattern) }
    raise "Unresolved mapping for #{value}" if pattern.nil?
    mapping[value] = pattern
  end

  def unsolved
    patterns - solved
  end

  def solved
    mapping.values.flatten
  end
end

def part1(patterns_outputs)
  distinct_segment_counts = [2, 4, 3, 7]

  patterns_outputs.sum do |_patterns, outputs|
    outputs.count { |output| distinct_segment_counts.include?(output.size) }
  end
end

def part2(patterns_outputs)
  patterns_outputs.sum do |patterns, outputs|
    OutputPatternMapper.new(patterns: patterns, outputs: outputs).solve
  end
end

def parse_patterns(patterns)
  patterns.split(" ").map { |pattern| Set.new(pattern.chars.sort) }
end

patterns_outputs = ARGF.readlines.each_with_object({}) do |line, memo|
  patterns, outputs = line.chomp.split(" | ")
  memo[parse_patterns(patterns)] = parse_patterns(outputs)
end

puts "Part 1:", part1(patterns_outputs)
puts "Part 2:", part2(patterns_outputs)
