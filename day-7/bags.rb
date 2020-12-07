require "pry"

RULES = ARGF.each_with_object({}) do |raw_rule, result|
  outer_bag, raw_inner_bags = raw_rule.split(" bags contain ")
  inner_bags = raw_inner_bags
    .scan(/(\d+)\s([\w\s]+)\sbag/)
    .map { |qty, color| [color, qty.to_i] }.to_h

  result[outer_bag] = inner_bags
end

def find_outer_bags_for(color)
  RULES.filter { |_, inner_bags| inner_bags.key?(color) }.keys
end

def distinct_outer_bags_for(color)
  search_list = [color]
  outer_bags = []

  while (next_color = search_list.pop)
    bags = find_outer_bags_for(next_color)
    search_list += bags
    outer_bags += bags
  end

  outer_bags.uniq.size
end

def inner_bags_quantities_for(color)
  RULES[color].inject(1) do |answer, (inner_color, quantity)|
    inner_quantity = inner_bags_quantities_for(inner_color)
    answer + (quantity * inner_quantity)
  end
end

puts "Part 1:", distinct_outer_bags_for("shiny gold")
puts "Part 2:", inner_bags_quantities_for("shiny gold") - 1
