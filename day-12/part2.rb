instructions = ARGF.readlines(chomp: true)

ship_x = 0
ship_y = 0
waypoint_x = 10
waypoint_y = 1

instructions.each_with_index do |instruction|
  action = instruction[0]
  value = instruction[1..].to_i

  case action
  when "F"
    ship_x += (waypoint_x * value)
    ship_y += (waypoint_y * value)
  when "N"
    waypoint_y += value
  when "E"
    waypoint_x += value
  when "S"
    waypoint_y -= value
  when "W"
    waypoint_x -= value
  when "R"
    (value / 90).times do
      waypoint_x, waypoint_y = waypoint_y, -waypoint_x
    end
  when "L"
    (value / 90).times do
      waypoint_x, waypoint_y = -waypoint_y, waypoint_x
    end
  end
end

puts "e/w #{ship_x.abs}, n/s #{ship_y.abs}"
