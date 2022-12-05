# This script was written for the advent of code 2022 day 5.
# https://adventofcode.com/2022/day/5

require 'uri'
require 'net/http'

class Solver
  def initialize(day, year = 2022)
    @day = day
    @year = year
  end

  def decipher
    fetch_input
    first_answer = solve_first(@input)
    puts "the first answer is: #{first_answer}"
    second_answer = solve_second(@input)
    puts "the second answer is: #{second_answer}"
  end

  def fetch_input
    filename = 'cookie.txt'
    unless File.exist?(filename)
      abort('"cookie.txt" is required to get the puzzle input for your account.')
    end

    file = File.open(filename)

    uri = URI("https://adventofcode.com/#{@year}/day/#{@day}/input")
    cookie_value = file.read.chomp
    user_agent = 'github.com/naturaln0va/aoc2022 by Ryan Ackermann'
    headers = { 'Cookie' => "session=#{cookie_value}", 'User-Agent' => user_agent }
    
    file.close

    puts "fetching the puzzle input for day #{@day}..."
    res = Net::HTTP.get_response(uri, headers)

    unless res.is_a?(Net::HTTPSuccess)
      abort(res.body)
    end
    
    @input = res.body
  end

  def test_case
    test_input = "    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    parts = input.split("\n\n")
    
    stacks_layout = parts.first.lines
    
    stack_ids = stacks_layout.pop.split("   ").map(&:strip)
    stacks_count = stack_ids.length
    
    stack_lines = stacks_layout.reverse
    columns = Hash.new { |h,k| h[k] = [] }
    
    for line in stack_lines
      chars = line.chars
      
      for index in (0..stacks_count)
        search_index = (index * 3) + index + 1
        
        if search_index < chars.length
          found_char = chars[search_index]
          columns[index] << found_char if found_char != " "
        end
      end
    end
    
    instructions = parts.last.lines
    
    for line in instructions
      parts = line.split
      amount_to_move = parts[1].to_i
      src_col = parts[3].to_i - 1
      dst_col = parts[5].to_i - 1
      
      amount_to_move.times do
        src = columns[src_col]
        dst = columns[dst_col]
        dst << src.pop
        columns[src_col] = src
        columns[dst_col] = dst
      end
    end
    
    columns.values.map(&:last).join
  end

  def solve_second(input)
    parts = input.split("\n\n")
    
    stacks_layout = parts.first.lines
    
    stack_ids = stacks_layout.pop.split("   ").map(&:strip)
    stacks_count = stack_ids.length
    
    stack_lines = stacks_layout.reverse
    columns = Hash.new { |h,k| h[k] = [] }
    
    for line in stack_lines
      chars = line.chars
      
      for index in (0..stacks_count)
        search_index = (index * 3) + index + 1
        
        if search_index < chars.length
          found_char = chars[search_index]
          columns[index] << found_char if found_char != " "
        end
      end
    end
    
    instructions = parts.last.lines

    for line in instructions
      parts = line.split
      amount_to_move = parts[1].to_i
      src_col = parts[3].to_i - 1
      dst_col = parts[5].to_i - 1
      
      src = columns[src_col]
      dst = columns[dst_col]
      dst += src.pop(amount_to_move)
      columns[src_col] = src
      columns[dst_col] = dst
    end
    
    columns.values.map(&:last).join
  end
end

s = Solver.new(day = 5)
# s.decipher
s.test_case
