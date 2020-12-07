answers_by_group = ARGF.read.split("\n\n").map do |group|
  group.split("\n").map(&:chars)
end

unique_count = answers_by_group.sum do |group|
  group.flatten.uniq.size
end

all_answered_count = answers_by_group.sum do |group|
  group.first.intersection(*group).size
end

puts "Part 1 - unique count:", unique_count
puts "Part 2 - intersection:", all_answered_count
