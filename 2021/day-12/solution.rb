# frozen_string_literal: true

SMALL_CAVE = /\A[a-z]{1,2}\z/

Pair = Struct.new(:lhs, :rhs) do
  def start?
    lhs == "start"
  end

  def end?
    rhs == "end"
  end

  def reverse
    Pair.new(rhs, lhs)
  end
end

class Path
  attr_reader :values

  def self.from_starting_places(pairs)
    pairs.filter(&:start?).map { |starting_pair| new([starting_pair]) }
  end

  def initialize(pairs)
    @values = pairs
  end

  def complete?
    values.last.end?
  end

  def add_connections(pairs, &block)
    return self if complete?

    last_place = values.last.rhs

    next_places = pairs.filter do |pair|
      (last_place == pair.lhs) && within_small_cave_threshold(pair.rhs, &block)
    end

    next_places.map { |pair| Path.new(values + [pair]) }
  end

  def to_s
    visited_places.join(",")
  end

  def visited_small_caves
    @visited_small_caves ||= visited_places.filter { |place| place.match?(SMALL_CAVE) }
  end

  private

  def within_small_cave_threshold(destination, &block)
    return true unless destination.match?(SMALL_CAVE)

    block.call(destination, self)
  end

  def visited_places
    @visited_places ||= values.map(&:rhs).prepend("start")
  end
end

def parse_input
  ARGF.readlines(chomp: true).flat_map do |line|
    a, b = line.split("-")

    if a == "start" || b == "end"
      Pair.new(a, b)
    elsif b == "start" || a == "end"
      Pair.new(b, a)
    else
      [Pair.new(a, b), Pair.new(b, a)]
    end
  end
end

def solve(pairs, &block)
  paths = Path.from_starting_places(pairs)

  until paths.all?(&:complete?)
    paths = paths.flat_map { |path| path.add_connections(pairs, &block) }
  end

  paths
end

pairs = parse_input

part1_paths = solve(pairs) do |small_cave, path|
  !path.visited_small_caves.include?(small_cave)
end

puts "Part 1", part1_paths.count

part2_paths = solve(pairs) do |small_cave, path|
  case path.visited_small_caves.count(small_cave)
  when 0 then true
  when 2 then false
  else
    other_small_caves = (path.visited_small_caves - [small_cave])
    !other_small_caves.tally.value?(2)
  end
end

puts "Part 2", part2_paths.count
