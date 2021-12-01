#!/usr/bin/env ruby

combination_size = ARGV.first.to_i
expenses_path = File.expand_path("expenses.txt", __dir__)
expenses = File.readlines(expenses_path).map(&:to_i)

expenses
  .combination(combination_size)
  .detect { |expenses| expenses.sum == 2020 }
  .tap do |expenses|
    break if expenses.nil?

    combination = expenses.join(" * ")
    answer = expenses.inject(:*)
    puts "#{combination} = #{answer}"
  end
