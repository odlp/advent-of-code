FLOOR = "."
EMPTY_SEAT = "L"
OCCUPIED_SEAT = "#"
DIRECTIONS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

seats = ARGF.each_line(chomp: true).map { |row| row.chars }

def adjacent_seats(seats:, seat_x:, seat_y:, adjacent_distance:)
  Enumerator.new do |yielder|
    DIRECTIONS.each do |offset_x, offset_y|
      1.upto(adjacent_distance) do |distance|
        x = (offset_x * distance) + seat_x
        y = (offset_y * distance) + seat_y

        break if y.negative? || seats[y].nil?
        break if x.negative? || seats[y][x].nil?

        if (space = seats[y][x]) != FLOOR
          break yielder << space
        end
      end
    end
  end
end

def perform_iteration(seats:, occupied_threshold:, adjacent_distance:)
  changes = []

  seats.each_with_index do |row, y|
    row.each_with_index do |space, x|
      next if space == FLOOR

      occupied_count = adjacent_seats(seats: seats, seat_x: x, seat_y: y, adjacent_distance: adjacent_distance)
        .count(OCCUPIED_SEAT)

      if space == EMPTY_SEAT && occupied_count == 0
        changes << { x: x, y: y, value: OCCUPIED_SEAT }
      end

      if space == OCCUPIED_SEAT && occupied_count >= occupied_threshold
        changes << { x: x, y: y, value: EMPTY_SEAT }
      end
    end
  end

  changes.each do |change|
    seats[change.fetch(:y)][change.fetch(:x)] = change.fetch(:value)
  end
end

def solve_until_no_changes(seats:, occupied_threshold:, adjacent_distance:)
  prev_count, count = -1, 0

  until count == prev_count do
    perform_iteration(seats: seats, occupied_threshold: occupied_threshold, adjacent_distance: adjacent_distance)
    prev_count, count = count, seats.flatten.count(OCCUPIED_SEAT)
  end

  count
end

puts "Part 1:", solve_until_no_changes(seats: seats.dup, occupied_threshold: 4, adjacent_distance: 1)
puts "Part 2:", solve_until_no_changes(seats: seats.dup, occupied_threshold: 5, adjacent_distance: seats.size)
