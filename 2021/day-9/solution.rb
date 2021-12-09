# Usage: ruby solution.rb input.txt

require "matrix"
require "set"

DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
NOT_BASIN = 9

input = ARGF.readlines.map { |line| line.chomp.chars.map(&:to_i) }
grid = Matrix[*input]

def find_adjacent_positions(grid, starting_row, starting_col)
  max_row = grid.row_count - 1
  max_col = grid.column_count - 1

  DIRECTIONS.filter_map do |row_offset, col_offset|
    row = starting_row + row_offset
    col = starting_col + col_offset

    [row, col] if row.between?(0, max_row) && col.between?(0, max_col)
  end
end

def find_adjacent_values(grid, row, col)
  find_adjacent_positions(grid, row, col).map { |row, col| grid.element(row, col) }
end

def part1(grid)
  grid.each_with_index.sum do |value, row, col|
    adjacent_values = find_adjacent_values(grid, row, col)
    lowest = adjacent_values.all? { |adjacent_value| adjacent_value > value }
    lowest ? (value + 1) : 0
  end
end

def part2(grid)
  basin_groups = Set.new
  known_basin_positions = Set.new

  grid.each_with_index do |value, row, col|
    next if value == NOT_BASIN
    next if known_basin_positions.include?([row, col])

    basin = Set.new
    todo = [[row, col]]

    while position = todo.shift
      adjacent = find_adjacent_positions(grid, *position).reject do |xy|
        grid.element(*xy) == NOT_BASIN || basin.include?(xy)
      end

      todo.concat(adjacent)
      basin << position
    end

    basin_groups << basin
    known_basin_positions.merge(basin)
  end

  basin_groups.map(&:size).sort.last(3).reduce(:*)
end

puts "Part 1:", part1(grid)
puts "Part 2:", part2(grid)
