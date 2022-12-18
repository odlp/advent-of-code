# frozen_string_literal: true

input = ARGF.readlines(chomp: true).map(&:chars)
priorities = ("a".."z").to_a + ("A".."Z").to_a

common_items = input.flat_map do |rucksack|
  midpoint = rucksack.size / 2
  rucksack.first(midpoint) & rucksack.last(midpoint)
end

puts "Part 1:", common_items.sum { |item| priorities.index(item) + 1 }

group_badges = input.each_slice(3).flat_map do |rucksack_1, rucksack_2, rucksack_3|
  rucksack_1 & rucksack_2 & rucksack_3
end

puts "Part 2:", group_badges.sum { |item| priorities.index(item) + 1 }
