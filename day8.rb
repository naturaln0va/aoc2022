# This script was written for the advent of code 2022 day 8.
# https://adventofcode.com/2022/day/8

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
    test_input = "30373
    25512
    65332
    33549
    35390"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    lines = input.lines.map(&:strip)
    width = lines.first.chars.length
    height = lines.length
    values = lines.join.chars.map(&:to_i)
    
    visible_values = []
    values.each_with_index do |value, index|
      row = index % width
      col = index / height
      
      # west
      west_clear = true
      for x in (0...row)
        v = values[height * col + x]
        if v >= value
          west_clear = false
          break
        end
      end
      if west_clear
        visible_values << value
        next
      end
      
      # north
      north_clear = true
      for y in (0...col)
        v = values[height * y + row]
        if v >= value
          north_clear = false
          break
        end
      end
      if north_clear
        visible_values << value
        next
      end
      
      # east
      east_clear = true
      for x in (1...(width - row))
        v = values[height * col + (row + x)]
        if v >= value
          east_clear = false
          break
        end
      end
      if east_clear
        visible_values << value
        next
      end
      
      # south
      south_clear = true
      for y in (1...(height - col))
        v = values[height * (col + y) + row]
        if v >= value
          south_clear = false
          break
        end
      end
      if south_clear
        visible_values << value
        next
      end
    end
    
    visible_values.length
  end

  def solve_second(input)
    lines = input.lines.map(&:strip)
    width = lines.first.chars.length
    height = lines.length
    values = lines.join.chars.map(&:to_i)
    
    scenic_scores = []
    values.each_with_index do |value, index|
      row = index % width
      col = index / height
      cardinal_scores = []
      
      # west
      west_score = 0
      for x in (0...row).to_a.reverse
        v = values[height * col + x]
        west_score += 1
        if v >= value
          break
        end
      end
      cardinal_scores << west_score
      
      # north
      north_score = 0
      for y in (0...col).to_a.reverse
        v = values[height * y + row]
        north_score += 1
        if v >= value
          break
        end
      end
      cardinal_scores << north_score
      
      # east
      east_score = 0
      for x in (1...(width - row))
        v = values[height * col + (row + x)]
        east_score += 1
        if v >= value
          break
        end
      end
      cardinal_scores << east_score
      
      # south
      south_score = 0
      for y in (1...(height - col))
        v = values[height * (col + y) + row]
        south_score += 1
        if v >= value
          break
        end
      end
      cardinal_scores << south_score
      
      score = cardinal_scores.inject(:*)
      puts "(#{row}, #{col}) = #{cardinal_scores} - #{score}"
      scenic_scores << score
    end
    
    scenic_scores.max
  end
end

s = Solver.new(day = 8)
# s.decipher
s.test_case
