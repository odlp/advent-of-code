require "pry"

RULES = ARGF.map do |raw_rule|
  outer_bag, raw_inner_bags = raw_rule.split(" bags contain ")
  inner_bags = {}
  raw_inner_bags.scan(/(\d+)\s([\w\s]+)\sbag/).each do |qty, color|
    inner_bags[color] = qty.to_i
  end

  [outer_bag, inner_bags]
end.to_h

def find_outer_bags_for(color)
  RULES.filter do |outer, inner_bags|
    inner_bags.key?(color)
  end.keys
end

def distinct_outer_bags_for(color)
  answers = []
  search_list = [color]

  while(next_color = search_list.pop)
    bags = find_outer_bags_for(next_color)
    search_list += bags
    answers += bags
  end

  answers.uniq.size
end

puts "Part 1:", distinct_outer_bags_for("shiny gold")
