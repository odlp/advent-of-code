spoken = ARGV.first.split(",").map(&:to_i)
target_spoken = ARGV.last.to_i

until spoken.length == target_spoken
  if spoken.count(spoken.last) == 1
    spoken << 0
  else
    penultimate = spoken[0...-1].rindex(spoken.last)
    next_up = (spoken.size - 1) - penultimate
    spoken << next_up
  end
end

puts "#{spoken.last} (##{spoken.size})"
