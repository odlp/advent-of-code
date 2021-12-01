boarding_pass_ids = ARGF.map do |raw_boarding_pass|
  raw_boarding_pass.tr("FBLR", "0101").to_i(2)
end

puts "Part 1:", boarding_pass_ids.max
puts "Part 2:", boarding_pass_ids
  .sort
  .each_cons(2)
  .detect { |id1, id2| id2 - id1 != 1 }
