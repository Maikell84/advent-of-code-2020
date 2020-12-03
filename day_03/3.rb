#!/usr/bin/env ruby
file = File.open('3.txt')
path_data = file.readlines.map(&:chomp)
# since we go up to 7 right and 1 down, the path must be 7 times as wide as it is high.
@path_data = path_data.map { |line| line * path_data.count * 7 }

def count_trees_for_path(x_step_size, y_step_size)
  trees = 0
  x_value = 0
  @path_data.each.with_index(0) do |line, i|
    next if skip_line?(i, y_step_size)

    x_value += x_step_size
    trees += 1 if line[x_value] == '#'
  end
  trees
end

def skip_line?(i, y_step_size)
  return true if i.zero?
  return true if i.odd? && y_step_size == 2

  false
end

trees_part_1 = count_trees_for_path(3, 1)
puts "Part 1: Found #{trees_part_1} trees"
trees_part_2_1 = count_trees_for_path(1, 1)
trees_part_2_2 = count_trees_for_path(3, 1)
trees_part_2_3 = count_trees_for_path(5, 1)
trees_part_2_4 = count_trees_for_path(7, 1)
trees_part_2_5 = count_trees_for_path(1, 2)
puts "Part 2: Product of all encountered trees: #{trees_part_2_1 * trees_part_2_2 * trees_part_2_3 * trees_part_2_4 * trees_part_2_5}"
