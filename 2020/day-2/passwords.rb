#!/usr/bin/env ruby

input_path = File.expand_path("passwords.txt", __dir__)
PasswordEntry = Struct.new(:character, :range, :password, keyword_init: true)

password_entries = File.readlines(input_path).map do |line|
  start_finish_part, character_part, password = line.split(" ")
  start, finish = start_finish_part.split("-").map(&:to_i)
  character = character_part.delete_suffix(":")

  PasswordEntry.new(character: character, range: start..finish, password: password)
end

answer_part_1 = password_entries.count do |entry|
  entry.range.include?(entry.password.count(entry.character))
end

answer_part_2 = password_entries.count do |entry|
  [entry.range.begin, entry.range.end].one? do |position|
    index = position - 1
    entry.password[index] == entry.character
  end
end

puts "Part 1: #{answer_part_1}", "Part 2: #{answer_part_2}"
