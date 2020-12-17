ACTIVE = "#"
INACTIVE = "."
DIRECTIONS = [-1, 0, 1]
ALL_DIRECTIONS = DIRECTIONS.product(DIRECTIONS, DIRECTIONS)

Cube = Struct.new(:x, :y, :z, keyword_init: true) do
  def neighbours
    @neighbours ||= begin
      all = ALL_DIRECTIONS.map do |offset_x, offset_y, offset_z|
        Cube.new(x: x + offset_x, y: y + offset_y, z: z + offset_z)
      end

      all - [self]
    end
  end

  def to_s
    "<Cube x:#{x} y:#{y} z:#{z}>"
  end
end

grid = ARGF.flat_map.with_index do |line, y|
  line.chomp.chars.map.with_index do |state, x|
    [Cube.new(x: x, y: y, z: 0), state]
  end
end.to_h

6.times do |n|
  changes = {}
  in_scope_cubes = (grid.keys + grid.keys.flat_map(&:neighbours)).uniq

  in_scope_cubes.each do |cube|
    active_neighbours = cube.neighbours.count do |neighbour|
      grid[neighbour] == ACTIVE
    end

    state = grid.fetch(cube, INACTIVE)

    if state == ACTIVE && active_neighbours.between?(2, 3)
      changes[cube] = ACTIVE
    elsif state == INACTIVE && active_neighbours == 3
      changes[cube] = ACTIVE
    else
      changes[cube] = INACTIVE
    end
  end

  grid.merge!(changes)
end

puts "Part 1:", grid.values.count(ACTIVE)
