bus_ids = ARGF.readlines(chomp: true)[1].split(",").map do |bus_id|
  if bus_id == "x"
    bus_id
  else
    bus_id.to_i
  end
end

start_near = ENV.fetch("START_NEAR", 0).to_i
start_from = Range.new(start_near - bus_ids.first, start_near + bus_ids.first).detect do |num|
  num % bus_ids.first == 0
end

puts "Starting from: #{start_from}"

result = (start_from..).step(bus_ids.first).detect do |departure_timestamp|
  puts "#{departure_timestamp}"

  bus_ids[1..].each.with_index(1).all? do |other_bus_id, offset|
    if other_bus_id == "x"
      true
    else
      target_departure_time = departure_timestamp + offset
      (target_departure_time % other_bus_id) == 0
    end
  end
end

puts "Part 2:", result
