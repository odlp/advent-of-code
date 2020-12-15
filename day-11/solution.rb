FLOOR = "."
EMPTY_SEAT = "L"
OCCUPIED_SEAT = "#"

seats = ARGF.each_line(chomp: true).map { |row| row.chars }

def adjacent_seats(seats:, seat_x:, seat_y:, adjacent_depth:)
  Enumerator.new do |yielder|
    [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0],           [1, 0],
      [-1, 1],  [0, 1],  [1, 1],
    ].each do |offset_x, offset_y|
      1.upto(adjacent_depth) do |n|
        x = (offset_x * n) + seat_x
        y = (offset_y * n) + seat_y

        if y >= 0 && row = seats[y]
          if x >= 0 && space = row[x]
            if space != FLOOR
              yielder << space
              break
            end
          end
        end
      end
    end
  end
end

def perform_iteration(seats, occupied_threshold:, adjacent_depth:)
  changes = []

  seats.each_with_index do |row, y|
    row.each_with_index do |space, x|
      next if space == FLOOR

      occupied_count = adjacent_seats(seats: seats, seat_x: x, seat_y: y, adjacent_depth: adjacent_depth)
        .count { |seat| seat == OCCUPIED_SEAT }

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

def solve_until_no_changes(seats, occupied_threshold:, adjacent_depth:)
  count = 0
  prev_count = -1

  until count == prev_count do
    perform_iteration(seats, occupied_threshold: occupied_threshold, adjacent_depth: adjacent_depth)
    prev_count = count
    count = seats.flatten.count { |seat| seat == OCCUPIED_SEAT }
  end

  count
end

puts "Part 1:", solve_until_no_changes(seats.dup, occupied_threshold: 4, adjacent_depth: 1)
puts "Part 2:", solve_until_no_changes(seats.dup, occupied_threshold: 5, adjacent_depth: seats.size)
