# frozen_string_literal: true

DOT = "#"

def fold_vertically(grid, fold_at)
  top    = grid[..(fold_at.pred)]
  bottom = grid[fold_at.succ..]
  offset = top.size - bottom.size

  bottom.reverse_each.with_index(offset) do |row, flipped_y|
    row.each_with_index do |value, x|
      next unless value == DOT
      top[flipped_y][x] = value
    end
  end

  top
end

def fold_horizontally(grid, fold_at)
  lhs    = grid.map { |row| row[..(fold_at.pred)] }
  rhs    = grid.map { |row| row[fold_at.succ..] }
  offset = lhs.size - rhs.size

  rhs.each_with_index do |row, y|
    row.reverse_each.with_index(offset) do |value, flipped_x|
      next unless value == DOT
      lhs[y][flipped_x] = value
    end
  end

  lhs
end

def solve(grid, instructions)
  instructions.each do |instruction|
    fold_at = instruction.split("=").last.to_i

    grid = if instruction.include?("y=")
      fold_vertically(grid, fold_at)
    else
      fold_horizontally(grid, fold_at)
    end
  end

  grid
end

def build_grid(coordinates)
  row_count = coordinates.map(&:first).max + 1
  col_count = coordinates.map(&:last).max + 1

  Array.new(col_count) { Array.new(row_count, " ") }.tap do |grid|
    coordinates.each { |x, y| grid.fetch(y)[x] = DOT }
  end
end

coordinates, instructions = ARGF.read.split("\n\n")
coordinates = coordinates.split("\n").map { |line| line.split(",").map(&:to_i) }
instructions = instructions.split("\n")
grid = build_grid(coordinates)

puts "Part 1", solve(grid, instructions.first(1)).sum { |row| row.count(DOT) }
puts "Part 2:\n", solve(grid, instructions).map(&:join).join("\n")
