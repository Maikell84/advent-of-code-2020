#!/usr/bin/env ruby
file = File.open('10.txt')
@data = file.readlines.map(&:chomp).map(&:to_i).sort
@data << @data.max + 3

@one_joltage_differences = 0
@two_joltage_differences = 0
@three_joltage_differences = 0
$cache = {}

def find_steps(current_adapter_value)
  (1..3).each do |i|
    new_adapter_value = look_for(current_adapter_value, i)
    return find_steps(new_adapter_value) if new_adapter_value
  end
end

def look_for(target_joltage, step)
  target_joltage += step
  @data.each do |joltage|
    next unless joltage == target_joltage

    case step
    when 1
      @one_joltage_differences += 1
    when 2
      @two_joltage_differences += 1
    when 3
      @three_joltage_differences += 1
    else
      raise 'Did not find any suitable adapter'
    end

    return target_joltage
  end
  false
end

def find_combinations(current_end, available_adapters)
  return 1 if current_end == @data.max

  combination_count = 0
  (1..3).each do |i|
    next unless available_adapters.include?(current_end + i)

    remaining = available_adapters.select { |value| value > current_end + i }
    $cache[current_end + i] = find_combinations(current_end + i, remaining) if $cache[current_end + i].nil?
    combination_count += $cache[current_end + i]
  end
  combination_count
end

find_steps(0)
combinations = find_combinations(0, @data)

puts "1-joltage steps x 3-jotage-steps = #{@one_joltage_differences * @three_joltage_differences}"
puts "Possible adapter-combinations: #{combinations}"
