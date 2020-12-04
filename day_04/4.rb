#!/usr/bin/env ruby

class Array
  def compare(other_array)
    sort == other_array.sort
  end
end

def check_validity(passport_data)
  keys = passport_data.map(&:first)
  if @mandatory_fields.compare(keys - ['cid'])
    @valid_passports_part1 += 1
  else
    return
  end

  passport_data.each do |passport_item|
    return false unless validate(passport_item[0], passport_item[1])
  end
  @valid_passports_part2 += 1
end

def validate(key, value)
  case key
  when 'byr'
    (1920..2002).include?(value.to_i)
  when 'iyr'
    (2010..2020).include?(value.to_i)
  when 'eyr'
    (2020..2030).include?(value.to_i)
  when 'hgt'
    validate_height(value)
  when 'hcl'
    value.match(/^#(?:[0-9a-fA-F]{3}){1,2}$/)
  when 'ecl'
    %w[amb blu brn gry grn hzl oth].include?(value)
  when 'pid'
    value.length == 9 && (0..1_000_000_000).include?(value.to_i)
  when 'cid'
    true
  else
    false
  end
end

def validate_height(value)
  if value.end_with?('cm')
    number = value.split('cm').first
    number.to_i >= 150 && number.to_i <= 193
  elsif value.end_with?('in')
    number = value.split('in').first
    number.to_i >= 59 && number.to_i <= 76
  else
    false
  end
end

file = File.open('4.txt')
data = file.readlines.map(&:chomp)
@mandatory_fields = %w[byr iyr eyr hgt hcl ecl pid]
@valid_passports_part1 = 0
@valid_passports_part2 = 0
passport_data = []
data.each.with_index(0) do |line, _i|
  if line == ''
    check_validity(passport_data)
    passport_data = []
    next
  end

  passport_data.concat(line.split(' ').map { |p| p.split(':') })
end
check_validity(passport_data)

puts "Part 1: There are #{@valid_passports_part1} valid passports."
puts "Part 2: There are #{@valid_passports_part2} valid passports."
