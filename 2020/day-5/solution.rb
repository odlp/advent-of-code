ROW_RANGE = 0..127
COL_RANGE = 0..7
BoardingPass = Struct.new(:row, :col, :id, keyword_init: true)

def parse_boarding_pass(sequence)
  row = binary_seat_search(steps: sequence.first(7), range: ROW_RANGE)
  col = binary_seat_search(steps: sequence.last(3), range: COL_RANGE)
  id = (row * 8) + col

  BoardingPass.new(row: row, col: col, id: id)
end

def binary_seat_search(steps:, range:)
  lower_half = /L|F/

  steps.inject(range) do |value, step|
    half = value.size / 2
    step.match?(lower_half) ? value.first(half) : value.last(half)
  end.first
end

boarding_passes = ARGF.map do |raw_boarding_pass|
  parse_boarding_pass(raw_boarding_pass.chomp.chars)
end

puts "Part 1:", boarding_passes.max_by(&:id)

seated_between = boarding_passes
  .sort_by(&:id)
  .each_cons(2)
  .detect { |pass1, pass2| (pass2.id - pass1.id) != 1 }

puts "Part 2:", seated_between
