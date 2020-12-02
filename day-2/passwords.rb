#!/usr/bin/env ruby

challenge_part = ARGV.first.to_i
input_path = File.expand_path("passwords.txt", __dir__)

PasswordEntry = Struct.new(:character, :range, :password, keyword_init: true)

password_entries = File.readlines(input_path).map do |line|
  start_finish_part, character_part, password = line.split(" ")
  start, finish = start_finish_part.split("-").map(&:to_i)
  character = character_part.delete_suffix(":")

  PasswordEntry.new(character: character, range: start..finish, password: password)
end

# Part 1
min_max_occurrences_strategy = lambda do |entry|
  entry.range.include?(entry.password.count(entry.character))
end

# Part 2
one_occurrence_at_positions_strategy = lambda do |entry|
  [entry.range.begin, entry.range.end].one? do |position|
    index = position - 1
    entry.password[index] == entry.character
  end
end

strategy = if challenge_part == 1
  min_max_occurrences_strategy
else
  one_occurrence_at_positions_strategy
end

valid_count = password_entries.count(&strategy)

puts "Valid passwords: #{valid_count}"
