preamble = 25
sequence = ARGF.map(&:to_i)

invalid = sequence[preamble..-1].detect.with_index(preamble) do |number, index|
  window = Range.new(index - preamble, index - 1)

  sequence[window].permutation(2).none? do |prior1, prior2|
    prior1 + prior2 == number
  end
end

puts "Part 1:", invalid
