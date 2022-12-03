# This script was written for the advent of code 2022 day 3.
# https://adventofcode.com/2022/day/3

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
    test_input = "vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    priorities = ('a'..'z').to_a + ('A'..'Z').to_a
    
    input.lines
      .map(&:strip)
      .map { |line| line.chars.each_slice(line.length / 2).to_a }
      .map { |comps| (comps.first & comps.last).first }
      .map { |common| priorities.index(common) + 1 }
      .sum
  end

  def solve_second(input)
    priorities = ('a'..'z').to_a + ('A'..'Z').to_a
  
    input.lines
      .map(&:strip)
      .each_slice(3)
      .map { |group| group.map(&:chars).inject(:&).first }
      .map { |common| priorities.index(common) + 1 }
      .sum
  end
end

s = Solver.new(day = 3, year = 2022)
# s.decipher
s.test_case
