adapters = ARGF.map(&:to_i).sort
SOCKET = 0
chain = [SOCKET, *adapters, adapters.last + 3]

differences = chain
  .each_cons(2)
  .map { |adapter1, adapter2| adapter2 - adapter1 }
  .tally

puts "Part 1:", differences, differences.values.reduce(:*)

def calculate_permutations(n:, values:, cache:)
  return 0 unless values.include?(n)
  return 1 if n == SOCKET

  cache[n] ||= begin
    1.upto(3).sum do |offset|
      calculate_permutations(n: n - offset, values: values, cache: cache)
    end
  end
end

puts "Part 2:", calculate_permutations(n: chain.last, values: chain, cache: {})
