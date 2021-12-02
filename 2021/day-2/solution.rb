# Usage: ruby solution.rb input.txt

instructions = ARGF.readlines.map do |line|
  direction, amount = line.split
  [direction, amount.to_i]
end

def part1(instructions)
  horizontal, depth = 0, 0

  instructions.each do |direction, amount|
    case direction
    when "up"       then depth -= amount
    when "down"     then depth += amount
    when "forward"  then horizontal += amount
    end
  end

  { horizontal: horizontal, depth: depth, answer: depth * horizontal }
end

def part2(instructions)
  horizontal, depth, aim = 0, 0, 0

  instructions.each do |direction, amount|
    case direction
    when "up"   then aim -= amount
    when "down" then aim += amount
    when "forward"
      horizontal += amount
      depth += (aim * amount)
    end
  end

  { horizontal: horizontal, depth: depth, aim: aim, answer: depth * horizontal }
end

p part1(instructions)
p part2(instructions)
