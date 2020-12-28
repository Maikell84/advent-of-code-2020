#!/usr/bin/env ruby
groups = File.read('6.txt').split("\n\n")

anyone_yes_answers = 0
everyone_yes_answers = 0

groups.each do |group|
  # part 1
  anyone_yes_answers += group.gsub("\n", '').scan(/\w/).uniq.count

  # part 2
  group_answers = group.split("\n").map { |group_string| group_string.scan(/\w/).uniq }
  everyone_yes_answers += group_answers.reduce { |a, b| a & b }.count
end

puts "Total \"anyone-yes-answers\": #{anyone_yes_answers}"
puts "Total \"everyone-yes-answers\": #{everyone_yes_answers}"

