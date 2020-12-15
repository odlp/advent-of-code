spoken = Hash.new { |hash, key| hash[key] = [] }

ARGV.first.split(",").each.with_index(1) do |value, round|
  spoken[value.to_i] << round
end

max_rounds = ARGV.last.to_i
last_spoken = spoken.keys.last

(spoken.size + 1).upto(max_rounds) do |round|
  first_time = spoken[last_spoken].size == 1
  last_spoken = first_time ? 0 : (spoken[last_spoken][-1] - spoken[last_spoken][-2])
  spoken[last_spoken] << round
end

puts last_spoken
