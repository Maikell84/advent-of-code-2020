#!/usr/bin/env ruby

@count = 0
@results = []

def parse_data_part1(data, look_for)
  entries_to_look_for = look_for.uniq.count

  data.each do |bag_rule|
    bag_rule_array = bag_rule.split('contain').map(&:strip).map { |rule| rule.gsub('bags', 'bag') }

    leafs = bag_rule_array[1].split(',').map { |leaf| leaf.gsub('.', '') }
    leafs.each do |leaf|
      name = leaf.gsub(/\d+/, '').strip
      look_for << bag_rule_array[0] if look_for.include?(name)
    end
  end
  return parse_data_part1(data, look_for) if entries_to_look_for != look_for.uniq.count

  look_for
end

def parse_data_part2(data, results)
  @results << results
  new_nodes = parse_bag_data(data, results)

  new_nodes&.each do |node|
    parse_data_part2(data, node)
  end
end

def parse_bag_data(data, look_for)
  data.each do |bag_rule|
    old_level = look_for[:level]
    bag_rule_array = bag_rule.split('contain').map(&:strip).map { |rule| rule.gsub('bags', 'bag') }
    name = bag_rule_array[0]
    parent_name = name
    contains_parent = look_for[:contains_parent]

    next unless look_for[:name].include?(name)

    new_nodes = []

    leafs = bag_rule_array[1].split(',').map { |leaf| leaf.gsub('.', '') }
    leafs.each do |leaf|
      count = leaf.scan(/\d/).join('').to_i
      name = leaf.gsub(/\d+/, '').strip

      next if count.zero?

      new_nodes << { name: name, count: count, level: old_level + 1, parent: parent_name, contains_parent: contains_parent * count }
    end

    return new_nodes
  end

  nil
end

file = File.open('7.txt')
data = file.readlines.map(&:chomp)

look_for = ['shiny gold bag']
result_array_part1 = parse_data_part1(data, look_for)

look_for_part2 = { name: 'shiny gold bag', count: 1, level: 0, parent: '', contains_parent: 1 }
parse_data_part2(data, look_for_part2)

# We need to substract the bag itself
puts "Result Part 1: #{result_array_part1.uniq.count - 1}"
puts "Result Part 2: #{@results.sum { |h| h[:contains_parent] } - 1}"
