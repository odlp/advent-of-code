def mask_address(address:, mask:)
  address
    .rjust(mask.length, "0")
    .chars
    .zip(mask.chars)
    .map { |address_char, mask_char| mask_char == "0" ? address_char : mask_char }
    .join
end

def expand_floating_bits(address)
  floating_indexes = address.chars.each_index.select { |index| address[index] == "X" }

  binary_index_combinations(floating_indexes).map do |combination|
    modified_address = address.dup
    combination.each { |index, value| modified_address[index] = value }
    modified_address
  end
end

def binary_index_combinations(indexes)
  index_products = indexes.map { |index| [index].product(["0", "1"]) }
  index_products.first.product(*index_products[1..])
end

mem = {}
current_mask = nil

ARGF.each_line(chomp: true) do |line|
  instruction, value = line.split(" = ")

  if instruction.include?("mask")
    next current_mask = value
  end

  value = value.to_i
  original_address = instruction[/\d+/].to_i.to_s(2)
  masked_address = mask_address(address: original_address, mask: current_mask)

  expand_floating_bits(masked_address).each { |address| mem[address] = value }
end

puts "Part 2:", mem.values.sum
