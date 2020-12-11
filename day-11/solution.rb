require "pry"
require "matrix"

FLOOR = "."
EMPTY_SEAT = "L"
OCCUPIED_SEAT = "#"

seats = ARGF.each_line(chomp: true).map { |row| row.chars }

def adjacent_seats(seats:, seat_x:, seat_y:)
  Enumerator.new do |yielder|
    [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0],           [1, 0],
      [-1, 1],  [0, 1],  [1, 1],
    ].each do |offset_x, offset_y|
      x = offset_x + seat_x
      y = offset_y + seat_y

      if y >= 0 && row = seats[y]
        if x >= 0 && seat = row[x]
          yielder << seat
        end
      end
    end
  end
end

def perform_iteration(seats)
  changes = []

  seats.each_with_index do |row, y|
    row.each_with_index do |space, x|
      next if space == FLOOR

      occupied_count = adjacent_seats(seats: seats, seat_x: x, seat_y: y).count do |seat|
        seat == OCCUPIED_SEAT
      end

      if space == EMPTY_SEAT && occupied_count == 0
        changes << { x: x, y: y, value: OCCUPIED_SEAT }
      end

      if space == OCCUPIED_SEAT && occupied_count >= 4
        changes << { x: x, y: y, value: EMPTY_SEAT }
      end
    end
  end

  changes.each do |change|
    seats[change.fetch(:y)][change.fetch(:x)] = change.fetch(:value)
  end
end

def solve_until_no_changes(seats)
  count = 0
  prev_count = -1

  until count == prev_count do
    perform_iteration(seats)
    prev_count = count
    count = seats.flatten.count { |seat| seat == OCCUPIED_SEAT }
  end

  count
end

puts "Part 1: #{solve_until_no_changes(seats.dup)}"
