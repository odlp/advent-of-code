N_DIMENSIONS = ENV.fetch("N_DIMENSIONS", 4).to_i
DIMENSIONS = { x: nil, y: nil, z: 0, w: 0 }.first(N_DIMENSIONS).to_h

DIRECTIONS = [-1, 0, 1]
ALL_DIRECTIONS = DIRECTIONS.product(*Array.new(N_DIMENSIONS - 1, DIRECTIONS))

ACTIVE, INACTIVE = "#", "."

Cube = Struct.new(*DIMENSIONS.keys) do
  def neighbours
    @neighbours ||= ALL_DIRECTIONS.map { |offsets| offset_by(*offsets) } - [self]
  end

  def offset_by(*offsets)
    Cube.new(*values.zip(offsets).map(&:sum))
  end
end

grid = Hash.new.tap { |grid| grid.default = INACTIVE }

ARGF.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |state, x|
    attributes = DIMENSIONS.merge(x: x, y: y).values
    grid[Cube.new(*attributes)] = state
  end
end

6.times do
  changes = {}
  grid_and_neighbours = (grid.keys + grid.keys.flat_map(&:neighbours)).uniq

  grid_and_neighbours.each do |cube|
    active_neighbours = grid.values_at(*cube.neighbours).count(ACTIVE)

    if grid[cube] == ACTIVE && active_neighbours.between?(2, 3)
      next
    elsif grid[cube] == INACTIVE && active_neighbours == 3
      changes[cube] = ACTIVE
    else
      changes[cube] = INACTIVE
    end
  end

  grid.merge!(changes)
end

puts "Result:", grid.values.count(ACTIVE)
