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
    answer = solve_first(@input)
    puts "the first answer is: #{answer}"
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
    test_input = ""
    answer = solve_first(test_input)
    puts "the test answer is: #{answer}"
  end

  def solve_first(input)
    answer = 0
    numbers = input.split().map { |s| s.to_i }
    answer
  end

  def solve_second(input)
    answer = 0
    numbers = input.split().map { |s| s.to_i }
    answer
  end
end

s = Solver.new(day = 1, year = 2022)
# s.decipher
s.test_case
