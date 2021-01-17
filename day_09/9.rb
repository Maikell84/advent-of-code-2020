#!/usr/bin/env ruby
file = File.open('9.txt')
@data = file.readlines.map(&:chomp).map(&:to_i)
@preamble_length = 25

def can_build_sum?(number, index)
  (index - @preamble_length..index + @preamble_length).each do |i|
    (index - @preamble_length..index + @preamble_length).each do |j|
      next if i == j

      return true if @data[i] + @data[j] == number
    end
  end
  false
end

def look_for_number
  @data.each.with_index(0) do |number, i|
    next unless i > @preamble_length - 1

    return number unless can_build_sum?(number, i)
  end
end

def find_addends(target_number)
  highest_index = @data.index(target_number)
  found_indexes = []
  (0..highest_index).each do |i|
    @data[i]
    found_indexes = check_sum(i, target_number)
    break unless found_indexes == false
  end

  target_array = []
  (found_indexes[0]..found_indexes[1]).each do |i|
    target_array << @data[i]
  end

  target_array.min + target_array.max
end

def check_sum(index, target_number)
  temp_sum = @data[index]
  i = index + 1
  loop do
    temp_sum += @data[i]
    break if temp_sum == target_number
    return false if temp_sum > target_number

    i += 1
  end

  [index, i]
end

target_number = look_for_number
puts "Part 1: #{target_number}"

target_sum = find_addends(target_number)
puts "Part 2: #{target_sum}"
