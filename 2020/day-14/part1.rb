def mask_value(value:, mask:)
  value
    .rjust(mask.length, "0")
    .chars
    .zip(mask.chars)
    .map { |value_char, mask_char| mask_char == "X" ? value_char : mask_char }
    .join
end

mem = {}
current_mask = nil

ARGF.each_line(chomp: true) do |line|
  instruction, value = line.split(" = ")

  if instruction.include?("mask")
    next current_mask = value
  end

  address = instruction[/\d+/].to_i
  binary_value = value.to_i.to_s(2)
  mem[address] = mask_value(value: binary_value, mask: current_mask).to_i(2)
end

puts "Part 1:", mem.values.sum
