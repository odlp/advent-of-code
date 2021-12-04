# Usage: ruby solution.rb input.txt

require "matrix"

Cell = Struct.new(:value, :marked, keyword_init: true) do
  def mark_match(number)
    self.marked = true if value == number
  end
end

def find_winners(boards)
  boards.select do |board|
    (board.row_vectors + board.column_vectors).any? { |sequence| sequence.all?(&:marked) }
  end
end

def calculate_score(board, last_drawn_number)
  unmarked_sum = board.reject(&:marked).sum(&:value)
  unmarked_sum * last_drawn_number
end

def mark_matches(drawn_number, boards)
  boards.each do |board|
    board.each { |cell| cell.mark_match(drawn_number) }
  end
end

def find_first_winning_score(boards, bingo_numbers)
  boards = boards.dup
  bingo_numbers = bingo_numbers.dup

  until winner = find_winners(boards).first
    drawn_number = bingo_numbers.shift
    mark_matches(drawn_number, boards)
  end

  calculate_score(winner, drawn_number)
end

def find_last_winning_score(boards, bingo_numbers)
  boards = boards.dup
  bingo_numbers = bingo_numbers.dup
  winners = []

  until bingo_numbers.empty? || boards.empty?
    drawn_number = bingo_numbers.shift
    mark_matches(drawn_number, boards)
    winners += find_winners(boards)
    boards -= winners
  end

  calculate_score(winners.last, drawn_number)
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

puts "Part 1:", find_first_winning_score(boards, bingo_numbers)
puts "Part 2:", find_last_winning_score(boards, bingo_numbers)
