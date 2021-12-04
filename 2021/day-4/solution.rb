# Usage: ruby solution.rb input.txt

require "matrix"

Cell = Struct.new(:value, :marked, keyword_init: true)

def find_winners(boards)
  boards.select do |board|
    row_win = board.row_vectors.any? { |row| row.all?(&:marked) }
    column_win = board.column_vectors.any? { |column| column.all?(&:marked) }

    row_win || column_win
  end
end

def calculate_score(board, last_drawn_number)
  unmarked_sum = board.reject(&:marked).sum(&:value)
  unmarked_sum * last_drawn_number
end

def mark_matching_numbers(boards, drawn_number)
  boards.each do |board|
    board.each do |cell|
      if cell.value == drawn_number
        cell.marked = true
      end
    end
  end
end

def find_first_winner(boards, bingo_numbers)
  boards = boards.dup
  bingo_numbers = bingo_numbers.dup

  until winner = find_winners(boards).first || bingo_numbers.empty?
    drawn_number = bingo_numbers.shift
    mark_matching_numbers(boards, drawn_number)
  end

  [winner, drawn_number]
end

def find_last_winner(boards, bingo_numbers)
  boards = boards.dup
  bingo_numbers = bingo_numbers.dup
  winners = []

  until bingo_numbers.empty? || boards.empty?
    drawn_number = bingo_numbers.shift
    mark_matching_numbers(boards, drawn_number)
    winners += find_winners(boards)
    boards -= winners
  end

  [winners.last, drawn_number]
end

def parse_boards(raw_boards)
  raw_boards.map do |board|
    rows = board.split("\n").map do |row|
      row.split.map { |value| Cell.new(value: value.to_i, marked: false) }
    end

    Matrix[*rows]
  end
end

raw_numbers, *raw_boards = ARGF.read.split("\n\n")
bingo_numbers = raw_numbers.split(",").map(&:to_i)
boards = parse_boards(raw_boards)

puts "Part 1:", calculate_score(*find_first_winner(boards, bingo_numbers))
puts "Part 2:", calculate_score(*find_last_winner(boards, bingo_numbers))
