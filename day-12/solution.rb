instructions = ARGF.readlines(chomp: true)

directions = ["E", "S", "W", "N"]
current_direction = -> { directions.first }
east_west = 0
north_south = 0

instructions.each_with_index do |instruction|
  action = instruction[0]
  value = instruction[1..].to_i

  if action == "L"
    directions.rotate!(value / -90)
    next
  end

  if action == "R"
    directions.rotate!(value / 90)
    next
  end

  if action == "F"
    action = current_direction.call
  end

  case action
  when "N" then north_south += value
  when "E" then east_west += value
  when "S" then north_south -= value
  when "W" then east_west -= value
  end
end

puts "e/w #{east_west}, n/s #{north_south}"
