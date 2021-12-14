# frozen_string_literal: true

def solve(rounds:, template:, rules:)
  initial_tally = template.chars.each_cons(2).map(&:join).tally

  rounds.times.inject(initial_tally) do |tally|
    next_tally = Hash.new(0)

    tally.each do |element_pair, count|
      element1, element2 = element_pair.chars
      insert_element = rules.fetch(element_pair)

      next_tally[element1 + insert_element] += count
      next_tally[insert_element + element2] += count
    end

    next_tally
  end
end

def score(pair_tally)
  element_tally = Hash.new(0)

  pair_tally.each do |element_pair, count|
    element1, element2 = element_pair.chars
    element_tally[element1] += count
    element_tally[element2] += count
  end

  min, max = element_tally.values.minmax
  ((max - min) / 2.0).ceil
end

template, raw_rules = ARGF.read.split("\n\n")
rules = raw_rules.split("\n").to_h { |line| line.split(" -> ") }

puts "Part 1", score(solve(rounds: 10, template: template, rules: rules))
puts "Part 2", score(solve(rounds: 40, template: template, rules: rules))
