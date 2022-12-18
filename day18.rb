# This script was written for the advent of code 2022 day 18.
# https://adventofcode.com/2022/day/18

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
    test_input = "2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    points = input.lines.map(&:strip).map { |l| l.split(',').map(&:to_i) }
    
    total_surface_area = 0
    
    for point in points
      x, y, z = point[0], point[1], point[2]
      top = [x, y + 1, z]
      total_surface_area += 1 unless points.include?(top)
      bottom = [x, y - 1, z]
      total_surface_area += 1 unless points.include?(bottom)
      front = [x, y, z + 1]
      total_surface_area += 1 unless points.include?(front)
      back = [x, y, z - 1]
      total_surface_area += 1 unless points.include?(back)
      right = [x + 1, y, z]
      total_surface_area += 1 unless points.include?(right)
      left = [x - 1, y, z]
      total_surface_area += 1 unless points.include?(left)
    end
    
    total_surface_area
  end

  def solve_second(input)
    points = input.lines.map(&:strip).map { |l| l.split(',').map(&:to_i) }
    0
  end
end

s = Solver.new(day = 18)
# s.decipher
s.test_case
