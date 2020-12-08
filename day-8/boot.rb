require "set"

Instruction = Struct.new(:type, :value, :index, keyword_init: true)

original_instructions = ARGF.map.with_index do |raw_instruction, index|
  type, raw_value = raw_instruction.split(" ")
  Instruction.new(type: type, value: raw_value.to_i, index: index)
end

def execute(instructions)
  visited_instructions = Set.new
  last_index = instructions.size - 1
  accumulator = 0
  pointer = 0

  while current_instruction = instructions[pointer]
    if visited_instructions.include?(current_instruction)
      return [:looped, accumulator]
    end

    visited_instructions << current_instruction
    pointer = current_instruction.index + 1

    case current_instruction.type
    when "acc"
      accumulator += current_instruction.value
    when "jmp"
      pointer = current_instruction.index + current_instruction.value
    end

    if current_instruction.index == last_index
      return [:finished, accumulator]
    end
  end
end

puts "Part 1:", execute(original_instructions).last

TYPE_MUTATIONS = { "jmp" => "nop", "nop" => "jmp" }

mutants = original_instructions.map do |instruction|
  if (mutation = TYPE_MUTATIONS[instruction.type])
    instruction.dup.tap { |mutant| mutant.type = mutation }
  end
end.compact

mutants.detect do |mutant|
  revised_instructions = original_instructions.dup
  revised_instructions[mutant.index] = mutant
  halt_reason, value = execute(revised_instructions)

  if halt_reason == :finished
    puts "Part 2:", value
    true
  end
end
