#!/usr/bin/env ruby
def find_occurances(haystack, needle, occurances = 0)
  i = haystack.index(needle)
  return occurances if i.nil?

  occurances += 1
  modified_haystack = String.new(haystack)
  modified_haystack[i] = ''
  find_occurances(modified_haystack, needle, occurances)
end

def part1_password_valid?(occurance, letter, password)
  occurance = occurance.split('-').map(&:to_i)
  found_occurances = find_occurances(password, letter)
  occurance[0] <= found_occurances && found_occurances <= occurance[1]
end

def part2_password_valid?(positions, letter, password)
  positions_array = positions.split('-').map(&:to_i)

  (password[positions_array[0]-1] == letter && password[positions_array[1]-1] != letter) ||
  (password[positions_array[0]-1] != letter && password[positions_array[1]-1] == letter)
end

file = File.open('2.txt')
password_array = file.readlines.map(&:chomp)

invalid_passwords_part1 = []
invalid_passwords_part2 = []

password_array.each do |password_entry|
  entry = password_entry.split(' ')
  target_numbers = entry[0]
  target_letter = entry[1].split(':')[0]
  target_password = entry[2].freeze

  invalid_passwords_part1 << password_entry unless part1_password_valid?(target_numbers, target_letter, target_password)
  invalid_passwords_part2 << password_entry unless part2_password_valid?(target_numbers, target_letter, target_password)
end

puts "Part 1: Valid passwords: #{password_array.count - invalid_passwords_part1.count}"
puts "Part 2: Valid passwords: #{password_array.count - invalid_passwords_part2.count}"
