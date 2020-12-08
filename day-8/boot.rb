require "pry"

Instruction = Struct.new(:type, :value, :invocations, :index, keyword_init: true)

instructions = ARGF.map.with_index do |raw_instruction, index|
  type, raw_value = raw_instruction.split(" ")
  Instruction.new(type: type, value: raw_value.to_i, index: index, invocations: 0)
end

accumulator = 0
next_index = 0

while current_instruction = instructions[next_index]
  current_instruction.invocations += 1

  if current_instruction.invocations == 2
    break
  end

  next_index = current_instruction.index + 1

  case current_instruction.type
  when "acc"
    accumulator += current_instruction.value
  when "jmp"
    next_index = current_instruction.index + current_instruction.value
  end
end

puts "Part 1:", accumulator
