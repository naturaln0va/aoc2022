# This script was written for the advent of code 2022 day 9.
# https://adventofcode.com/2022/day/9

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
    test_input = "R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    larger_test_input = "R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20"
    second_answer = solve_second(larger_test_input)
    puts "the second test answer is: #{second_answer}"
  end
  
  def move_towards(x, y, target_x, target_y)
    if x != target_x and y != target_y
      dist = Integer.sqrt((target_x - x).pow(2) + (target_y - y).pow(2))
      return [x, y] unless dist.abs > 1
      x_diff = target_x - x
      x_sign = [1, 1, -1][x_diff <=> 0]
      x += x_sign
      y_diff = target_y - y
      y_sign = [1, 1, -1][y_diff <=> 0]
      y += y_sign
    elsif x == target_x and y != target_y
      diff = target_y - y
      sign = [1, 1, -1][diff <=> 0]
      y += sign if diff.abs > 1
    elsif y == target_y and x != target_x
      diff = target_x - x
      sign = [1, 1, -1][diff <=> 0]
      x += sign if diff.abs > 1
    end
    [x, y]
  end

  def solve_first(input)
    lines = input.lines.map(&:strip)
    
    hx, hy = 0, 0
    tx, ty = 0, 0
    tp = []
    
    for order in lines
      comps = order.split
      dir = comps.first
      amount = comps.last.to_i
      
      amount.times do
        case dir
          when 'U' then hy += 1
          when 'D' then hy -= 1
          when 'L' then hx -= 1
          when 'R' then hx += 1
        end
        
        tx, ty = move_towards(tx, ty, hx, hy)
        tp << "(#{tx}, #{ty})"
      end
    end
    
    tp.uniq.length
  end

  def solve_second(input)
    lines = input.lines.map(&:strip)
    
    segment_count = 10
    segments = Array.new(segment_count, [0, 0]).map(&:dup)
    
    tp = []
    
    for order in lines
      comps = order.split
      dir = comps.first
      amount = comps.last.to_i
      
      amount.times do
        segments.each_with_index do |seg, index|
          if index.zero?
            case dir
              when 'U' then seg[1] += 1
              when 'D' then seg[1] -= 1
              when 'L' then seg[0] -= 1
              when 'R' then seg[0] += 1
            end
          else
            target = segments[index - 1]
            seg[0], seg[1] = move_towards(seg[0], seg[1], target[0], target[1])
          end
          if index == segment_count - 1
            tp << "(#{seg[0]}, #{seg[1]})"
          end
        end
      end
    end
    
    tp.uniq.length
  end
end

s = Solver.new(day = 9)
# s.decipher
s.test_case
