# This script was written for the advent of code 2022 day 4.
# https://adventofcode.com/2022/day/4

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
    test_input = "2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    input.lines
      .map(&:strip)
      .map do |line|
        sections = line
          .split(',')
          .map do |pair|
            comps = pair.split('-').map(&:to_i)
            (comps.first..comps.last).to_a
          end
          .sort { |a, b| a.length <=> b.length }
        diff = (sections.first & sections.last)
        diff.length == sections.first.length ? 1 : 0
      end
      .sum
  end

  def solve_second(input)
    input.lines
    .map(&:strip)
    .map do |line|
      sections = line
        .split(',')
        .map do |pair|
          comps = pair.split('-').map(&:to_i)
          (comps.first..comps.last).to_a
        end
        .sort { |a, b| a.length <=> b.length }
      diff = (sections.first & sections.last)
      diff.length > 0 ? 1 : 0
    end
    .sum
  end
end

s = Solver.new(day = 4)
# s.decipher
s.test_case
