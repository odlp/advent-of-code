spoken = Hash.new { |hash, key| hash[key] = [] }

ARGV.first.split(",").each.with_index(1) do |value, index|
  spoken[value.to_i] << index
end

max_rounds = ARGV.last.to_i
last_spoken = spoken.keys.last

(spoken.size + 1).upto(max_rounds) do |round|
  last_spoken = if spoken[last_spoken].size == 1
    0
  else
    spoken[last_spoken][-1] - spoken[last_spoken][-2]
  end

  spoken[last_spoken] << round
end

puts last_spoken
