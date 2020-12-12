Coordinate = Struct.new(:x, :y, keyword_init: true)

instructions = ARGF.map { |line| [line[0], line[1..].to_i] }

def solve_part_1(instructions)
  directions = ["E", "S", "W", "N"]
  current_direction = -> { directions.first }
  ship = Coordinate.new(x: 0, y: 0)

  instructions.each_with_object(ship) do |(action, value), ship|
    if action == "F"
      action = current_direction.call
    end

    case action
    when "N" then ship.y += value
    when "E" then ship.x += value
    when "S" then ship.y -= value
    when "W" then ship.x -= value
    when "L" then directions.rotate!(value / -90)
    when "R" then directions.rotate!(value / 90)
    end
  end
end

def solve_part_2(instructions)
  ship = Coordinate.new(x: 0, y: 0)
  waypoint = Coordinate.new(x: 10, y: 1)

  instructions.each_with_object(ship) do |(action, value), ship|
    case action
    when "N" then waypoint.y += value
    when "E" then waypoint.x += value
    when "S" then waypoint.y -= value
    when "W" then waypoint.x -= value
    when "F"
      ship.x += (waypoint.x * value)
      ship.y += (waypoint.y * value)
    when "L"
      (value / 90).times { waypoint.x, waypoint.y = -waypoint.y, waypoint.x }
    when "R"
      (value / 90).times { waypoint.x, waypoint.y = waypoint.y, -waypoint.x }
    end
  end
end

dest1 = solve_part_1(instructions)
puts "Part 1", "e/w:", dest1.x, "n/s:", dest1.y, "distance:", dest1.x.abs + dest1.y.abs, "\n"

dest2 = solve_part_2(instructions)
puts "Part 2", "e/w:", dest2.x, "n/s:", dest2.y, "distance:", dest2.x.abs + dest2.y.abs, "\n"
