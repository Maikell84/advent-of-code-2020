#!/usr/bin/env ruby

file = File.open('5.txt')
data = file.readlines.map(&:chomp)

seat_ids = []
found_id = nil
highest_row = 0
highest_column_for_highest_row = 0

def column_from_row(boarding_pass_array)
  temp_column = (0..7).to_a
  (7..9).each do |i|
    if boarding_pass_array[i] == 'L'
      temp_column.pop(temp_column.length / 2)
    else
      temp_column.shift(temp_column.length / 2)
    end
  end
  temp_column
end

data.each do |boarding_pass|
  column = 0
  boarding_pass_array = boarding_pass.split('')

  temp = (0..127).to_a

  (0..6).each do |i|
    if boarding_pass_array[i] == 'B'
      temp.shift(temp.length / 2)
    else
      temp.pop(temp.length / 2)
    end
  end
  row_of_boarding_pass = temp[0]
  column_of_boarding_pass = column_from_row(boarding_pass_array)[0]

  id = (row_of_boarding_pass * 8) + column_of_boarding_pass
  seat_ids << id

  if temp[0] > highest_row
    highest_row = row_of_boarding_pass
    highest_column_for_highest_row = column_from_row(boarding_pass_array)[0]
  end

  if temp[0] == highest_row
    column = column_from_row(boarding_pass_array)[0]
    highest_column_for_highest_row = column if column > highest_column_for_highest_row
  end
end

seat_ids.sort!
seat_ids.each.with_index(0) do |seat_id, i|
  next if i.zero?

  found_id = seat_id + 1 if (seat_ids[i + 1] - seat_id) != 1
  break if found_id
end

puts "Highest Row: #{highest_row}"
puts "Highest Column of highest Row: #{highest_column_for_highest_row}"
puts "Highest ID: #{(highest_row * 8) + highest_column_for_highest_row}"
puts "Our Seat ID: #{found_id}"
