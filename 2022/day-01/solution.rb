# frozen_string_literal: true

calories_per_elf = ARGF.read
  .split("\n\n")
  .map { |group| group.split.sum(&:to_i) }
  .sort!
  .reverse!

puts "Part 1:", calories_per_elf.first
puts "Part 2:", calories_per_elf.first(3).sum
