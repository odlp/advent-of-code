Instruction = Struct.new(:type, :value, :invocations, :index, keyword_init: true)

original_instructions = ARGF.map.with_index do |raw_instruction, index|
  type, raw_value = raw_instruction.split(" ")
  Instruction.new(type: type, value: raw_value.to_i, index: index, invocations: 0)
end

def run_instructions(instructions)
  instructions = instructions.map(&:dup)
  accumulator = 0
  next_index = 0

  while current_instruction = instructions[next_index]
    if current_instruction.invocations == 1
      return [:looped, accumulator]
    end

    current_instruction.invocations += 1
    next_index = current_instruction.index + 1

    case current_instruction.type
    when "acc"
      accumulator += current_instruction.value
    when "jmp"
      next_index = current_instruction.index + current_instruction.value
    end

    if current_instruction.index == (instructions.size - 1)
      return [:finished, accumulator]
    end
  end
end

puts "Part 1:", run_instructions(original_instructions).last

mutants = original_instructions.map do |instruction|
  if instruction.type == "jmp"
    instruction.dup.tap { |mutant| mutant.type = "nop" }
  elsif instruction.type == "nop"
    instruction.dup.tap { |mutant| mutant.type = "jmp" }
  end
end.compact

mutants.detect do |mutant|
  revised_instructions = original_instructions.map(&:dup)
  revised_instructions[mutant.index] = mutant

  stop_reason, value = run_instructions(revised_instructions)

  if stop_reason == :finished
    puts "Part 2", value
    true
  end
end
