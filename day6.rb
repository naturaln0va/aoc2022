# This script was written for the advent of code 2022 day 6.
# https://adventofcode.com/2022/day/6

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
    test_input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    find_unique_marker(input, 4)
  end

  def solve_second(input)
    find_unique_marker(input, 14)
  end
  
  def find_unique_marker(input, target)
    chars = input.chars
    answer = 0
    
    chars.length.times do |i|
      part = chars.slice(i, target)
      
      if part.uniq.length == target
        answer = i + target
        break
      end
    end
    
    answer
  end
end

s = Solver.new(day = 6)
# s.decipher
s.test_case
