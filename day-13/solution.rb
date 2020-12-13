bus_ids = ARGF.read.scan(/(\d+)/).flatten.map(&:to_i)
earliest_departure = bus_ids.shift

bus_id, wait_time = bus_ids.map do |bus_id|
  max_wait = earliest_departure + bus_id
  nearest_departure = (0..max_wait).step(bus_id).detect do |time|
    time > earliest_departure
  end

  [bus_id, nearest_departure - earliest_departure]
end.min_by { |_, wait_time| wait_time }

puts "Part 1: #{wait_time * bus_id}"
