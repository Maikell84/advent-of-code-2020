#!/usr/bin/env ruby

file = File.open('1.txt')
numbers_array = file.readlines.map(&:chomp).map(&:to_i)
target_sum = 2020

# Part 1
puts "Part 1:\n"
numbers_array.each do |number|
  number_candidate = target_sum - number
  if numbers_array.index(number_candidate)
    puts "Found matching number pair: #{number_candidate} + #{number} = #{target_sum}"
    puts "Result is: #{number_candidate} x #{number} = #{number_candidate * number}\n\n"
    break
  end
end

# Part 2
puts "Part 2:\n"
found = false
numbers_array.each do |number_1|
  numbers_array.each do |number_2|
    break if found

    number_candidate = target_sum - number_1 - number_2
    if numbers_array.index(number_candidate)
      puts "Found matching number pair: #{number_candidate} + #{number_1} + #{number_2} = #{target_sum}"
      puts "Result is: #{number_candidate} x #{number_1} x #{number_2} = #{number_candidate * number_1 * number_2}\n\n"
      found = true
      break
    end
  end
end
