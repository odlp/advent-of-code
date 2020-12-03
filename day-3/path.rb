#!/usr/bin/env ruby

TREE = "#"

def count_trees(matrix, step_x, step_y)
  row_size = matrix.first.size
  x = 0

  (0...matrix.size).step(step_y).count do |y|
    square = matrix.fetch(y).fetch(x % row_size)
    x += step_x
    square == TREE
  end
end

matrix = ARGF.map { |line| line.chomp.chars }

puts "Part 1:", count_trees(matrix, 3, 1)

approaches = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]

puts "Part 2:", approaches.map { |x, y| count_trees(matrix, x, y) }.inject(:*)
