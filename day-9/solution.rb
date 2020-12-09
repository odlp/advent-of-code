PREAMBLE = 25
sequence = ARGF.map(&:to_i)

invalid = sequence.drop(PREAMBLE).detect.with_index(PREAMBLE) do |value, index|
  preceding_window = Range.new(index - PREAMBLE, index - 1)

  sequence[preceding_window]
    .permutation(2)
    .none? { |pair| pair.sum == value }
end

puts "Part 1:", invalid

pre_invalid = Range.new(0, sequence.index(invalid) - 1)

1.upto(pre_invalid.size).each do |n_consecutive|
  sequence[pre_invalid].each_cons(n_consecutive) do |values|
    if values.sum == invalid
      return puts "Part 2:", values.minmax.sum
    end
  end
end
