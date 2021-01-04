#!/usr/bin/env ruby

def load_program
  program = []
  file = File.open('8.txt')
  data = file.readlines.map(&:chomp)
  file.close
  @accumulator = 0

  data.each.with_index(0) do |instruction, i|
    name, value = instruction.split(' ')
    program << {
      name: name,
      value: value,
      visited: 0,
      index: i
    }
  end
  program
end

def reset_program
end

def do_instruction(instruction)
  mark_as_visited(instruction)
  case instruction[:name]
  when 'acc'
    adjust_accumulator(instruction[:value])
    instruction[:index] + 1
  when 'jmp'
    steps = jump(instruction[:value])
    instruction[:index] + steps
  when 'nop'
    instruction[:index] + 1
  end
end

def adjust_accumulator(value)
  if value.slice!(0) == '+'
    @accumulator += value.to_i
  else
    @accumulator -= value.to_i
  end
end

def jump(value)
  if value.slice!(0) == '+'
    value.to_i
  else
    -1 * value.to_i
  end
end

def mark_as_visited(instruction)
  raise 'This instruction has already been exectued!' if instruction[:visited] != 0

  instruction[:visited] += 1
end

def run_program(instruction, program)
  next_instruction_index = do_instruction(instruction)
  next_instruction = find_instruction(next_instruction_index, program)
  next_instruction.nil? ? @accumulator : run_program(next_instruction, program)
rescue StandardError => e
  puts e
  puts "Current accumulator value is #{@accumulator}"
end

def run_repaired_program(instruction, changed_jmp_occurance, instruction_type, repaired_program)
  next_instruction_index = do_instruction(instruction)
  next_instruction = find_instruction(next_instruction_index, repaired_program)

  next_instruction.nil? ? @accumulator : run_repaired_program(next_instruction, changed_jmp_occurance, instruction_type, repaired_program)
rescue StandardError => e
  new_jmp_occurance = changed_jmp_occurance + 1
  new_change_instruction = @program.select { |ins| ins[:name] == instruction_type }[new_jmp_occurance]
  return "Replaced all occurances of #{instruction_type} - no result!" if new_change_instruction.nil?

  index = new_change_instruction[:index]

  fixed_program = load_program.map(&:dup)
  fixed_program[index][:name] = inverted_instruction_type(instruction_type)

  # might need to increase stack size: export RUBY_THREAD_VM_STACK_SIZE=5000000
  run_repaired_program(fixed_program.first, new_jmp_occurance, instruction_type, fixed_program)
end

def find_instruction(index, program)
  program.find { |instruction| instruction[:index] == index }
end

def inverted_instruction_type(instruction_type)
  instruction_type == 'jmp' ? 'nop' : 'jmp'
end

@program = load_program
@program.freeze
puts 'Part 1:'
acc = run_program(@program.first, @program)
puts acc

@program = load_program
fixed_program = @program.map(&:dup)
puts 'Part 2:'
@changed_jmp_occurance = -1
acc = run_repaired_program(@program.first, @changed_jmp_occurance, 'jmp', fixed_program)

puts "Replaced 'jmp' with 'nop': #{acc}"

@changed_nop_occurance = -1
acc = run_repaired_program(@program.first, @changed_nop_occurance, 'nop', fixed_program)

puts "Replaced 'nop' with 'jmp': #{acc}"
