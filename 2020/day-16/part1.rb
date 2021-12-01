raw_rules, _raw_ticket, raw_other_tickets = ARGF.read.split("\n\n")

rules = raw_rules.split("\n").each_with_object({}) do |rule, memo|
  name, ranges = rule.split(": ")

  memo[name] = ranges.scan(/(\d+)-(\d+)/).map do |low, high|
    Range.new(low.to_i, high.to_i)
  end
end

other_tickets = raw_other_tickets.split("\n").drop(1).map do |ticket|
  ticket.scan(/\d+/).map(&:to_i)
end

error_rate = other_tickets.sum do |ticket_values|
  ticket_values.sum do |ticket_value|
    invalid = rules.values.flatten.none? { |range| range.include?(ticket_value) }
    invalid ? ticket_value : 0
  end
end

puts "Part 1:", error_rate
