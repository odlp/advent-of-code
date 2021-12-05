# Usage: ruby solution.rb input.txt

Line = Struct.new(:x1, :y1, :x2, :y2) do
  def horizontal?
    y1 == y2
  end

  def vertical?
    x1 == x2
  end

  def diagonal?
    !vertical? && !horizontal?
  end

  def points
    if diagonal?
      x_values.zip(y_values)
    elsif vertical?
      y_values.map { |y| [x1, y] }
    elsif horizontal?
      x_values.map { |x| [x, y1] }
    end
  end

  private

  def x_values
    direction = (x2 > x1) ? 1 : -1
    x1.step(to: x2, by: direction)
  end

  def y_values
    direction = (y2 > y1) ? 1 : -1
    y1.step(to: y2, by: direction)
  end
end

def solve(lines)
  grid = Hash.new(0)

  lines.each do |line|
    line.points.each { |point| grid[point] += 1 }
  end

  grid.values.count { |num| num >= 2 }
end

lines = ARGF.readlines.map do |raw_line|
  Line.new(*raw_line.scan(/\d+/).map(&:to_i))
end

puts "Part 1:", solve(lines.reject(&:diagonal?))
puts "Part 2:", solve(lines)
