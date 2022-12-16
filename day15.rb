# This script was written for the advent of code 2022 day 15.
# https://adventofcode.com/2022/day/15

require 'set'
require 'uri'
require 'net/http'

class Solver
  def initialize(day, year = 2022)
    @day = day
    @year = year
  end

  def decipher
    fetch_input
    first_answer = solve_first(@input, 2_000_000)
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
    test_input = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3"
    first_answer = solve_first(test_input, 10)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end
  
  def man_dist(a, b)
    (a[0] - b[0]).abs + (a[1] - b[1]).abs
  end

  def solve_first(input, target)
    lines = input.lines.map(&:strip).map { |l| l.scan(/-?\d+/).map(&:to_i) }
    occupied = Set.new
    
    for line in lines
      sx = line[0]
      sy = line[1]
      bx = line[2]
      by = line[3]
      
      sensor = [sx, sy]
      beacon = [bx, by]
      
      dist = man_dist(sensor, beacon)
      
      puts "s: #{sensor}\t b: #{beacon}\t d: #{dist}"
      length = dist * 2 + 1
      
      start_x = sx - dist
      start_y = sy - dist
      
      next if target < start_y or target > (start_y + length)
      
      change = (sy - target).abs
      
      for x in (0...(length - (change * 2)))
        occupied << [start_x + change + x, target]
      end
    end
    
    for line in lines
      beacon = [line[2], line[3]]
      occupied.delete(beacon)
    end
    
    occupied.length
  end

  def solve_second(input)
    lines = input.lines.map(&:strip).map { |l| l.scan(/-?\d+/).map(&:to_i) }
    
    pos_lines = []
    neg_lines = []
    
    for line in lines
      sx = line[0]
      sy = line[1]
      bx = line[2]
      by = line[3]
      
      dist = man_dist([sx, sy], [bx, by])
      
      neg_lines.concat [sx + sy - dist, sx + sy + dist]
      pos_lines.concat [sx - sy - dist, sx - sy + dist]
    end
    
    pos, neg = nil, nil
    check_count = lines.length * 2
    
    for i in (0...check_count)
      for j in ((i + 1)...check_count)
        a, b = pos_lines[i], pos_lines[j]
        pos = [a, b].min + 1 if (a - b).abs == 2
        
        a, b = neg_lines[i], neg_lines[j]
        neg = [a, b].min + 1 if (a - b).abs == 2
      end
    end
    
    x, y = (pos + neg) / 2, (neg - pos) / 2
    puts "x: #{x}, y: #{y}"
    x * 4_000_000 + y
  end
end

s = Solver.new(day = 15)
# s.decipher
s.test_case
