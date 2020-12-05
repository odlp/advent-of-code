ROW_RANGE = 0..127
COL_RANGE = 0..7

BoardingPass = Struct.new(:row, :col, :id, keyword_init: true)

def parse_boarding_pass(raw_boarding_pass)
  row = ROW_RANGE.dup
  col = COL_RANGE.dup

  row_steps, col_steps = raw_boarding_pass.chars.partition { |letter| letter.match?(/B|F/) }

  row_steps.each do |step|
    direction = step == "F" ? :first : :last
    row = row.public_send(direction, row.size / 2)
  end

  col_steps.each do |step|
    direction = step == "L" ? :first : :last
    n_items = [(col.size / 2), 1].max
    col = col.public_send(direction, n_items)
  end

  row = row.first
  col = col.first
  id = (row * 8) + col

  BoardingPass.new(row: row, col: col, id: id)
end

boarding_passes = ARGF.map do |raw_boarding_pass|
  parse_boarding_pass(raw_boarding_pass)
end

puts "Part 1:", boarding_passes.max_by(&:id)

seated_between = boarding_passes
  .sort_by(&:id)
  .each_cons(2)
  .detect { |a, b| b.id - a.id != 1 }

puts "Part 2: #{seated_between}"
