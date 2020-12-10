adapters = ARGF.map(&:to_i).sort
chain = [0, *adapters, adapters.last + 3]

differences = chain
  .each_cons(2)
  .map { |adapter1, adapter2| adapter2 - adapter1 }
  .tally

puts "Part 1:", differences, differences.values.reduce(:*)
