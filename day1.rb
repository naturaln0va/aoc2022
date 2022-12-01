# This script was written for the advent of code 2022 day 1.
# https://adventofcode.com/2022/day/1

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
    headers = { 'Cookie' => "session=#{cookie_value}" }
    
    file.close

    puts "fetching the puzzle input for day #{@day}..."
    res = Net::HTTP.get_response(uri, headers)

    unless res.is_a?(Net::HTTPSuccess)
      abort(res.body)
    end
    
    @input = res.body
  end

  def test_case
    test_input = "1000
    2000
    3000
    
    4000
    
    5000
    6000
    
    7000
    8000
    9000
    
    10000"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    numbers = input.split("\n").map { |s| s.chomp.to_i }
    
    best = 0
    current = 0
    
    for num in numbers
      if num == 0
        best = current if current > best
        current = 0
      else
        current += num
      end
    end
    
    best = current if current > best
    
    best
  end

  def solve_second(input)
    numbers = input.split("\n").map { |s| s.chomp.to_i }
    
    totals = []
    current = 0
    
    for num in numbers
      if num == 0
        totals.append(current)
        current = 0
      else
        current += num
      end
    end
    
    totals.append(current) if current > 0
    top_three = totals.sort.reverse.slice(0, 3)
    
    top_three.sum
  end
end

s = Solver.new(day = 1, year = 2022)
s.decipher
# s.test_case
