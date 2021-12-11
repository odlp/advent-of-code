require "matrix"

Octopus = Struct.new(:value, :flashed, keyword_init: true) do
  FLASH_THRESHOLD = 9

  def tick
    self.value += 1
  end

  def should_flash?
    self.value > FLASH_THRESHOLD && !self.flashed
  end

  def reset_flash
    return false unless self.flashed

    self.value = 0
    self.flashed = false
    true
  end
end

class Grid < Matrix
  NEIGHBOUR_OFFSETS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

  def neighbours(starting_row, starting_col)
    max_row = row_count - 1
    max_col = column_count - 1

    NEIGHBOUR_OFFSETS.filter_map do |row_offset, col_offset|
      row = starting_row + row_offset
      col = starting_col + col_offset
      within_bounds = row.between?(0, max_row) && col.between?(0, max_col)

      element(row, col) if within_bounds
    end
  end
end

def perform_round(grid)
  grid.each(&:tick)

  until grid.none?(&:should_flash?) do
    grid.each_with_index do |octopus, row, col|
      next unless octopus.should_flash?

      grid.neighbours(row, col).each(&:tick)
      octopus.flashed = true
    end
  end

  grid.count(&:reset_flash)
end

def build_grid(input)
  input = input.map { |row| row.map(&:dup) }
  Grid[*input]
end

def part1(grid)
  100.times.sum { perform_round(grid) }
end

def part2(grid)
  (1..).detect { |round| perform_round(grid) == grid.count }
end

input = ARGF.readlines(chomp: true).map do |line|
  line.chars.map { |value| Octopus.new(value: value.to_i, flashed: false) }
end

puts "Part 1:", part1(build_grid(input))
puts "Part 2:", part2(build_grid(input))
