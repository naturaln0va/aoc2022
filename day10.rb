# This script was written for the advent of code 2022 day 10.
# https://adventofcode.com/2022/day/10

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
    test_input = "addx 15
    addx -11
    addx 6
    addx -3
    addx 5
    addx -1
    addx -8
    addx 13
    addx 4
    noop
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx -35
    addx 1
    addx 24
    addx -19
    addx 1
    addx 16
    addx -11
    noop
    noop
    addx 21
    addx -15
    noop
    noop
    addx -3
    addx 9
    addx 1
    addx -3
    addx 8
    addx 1
    addx 5
    noop
    noop
    noop
    noop
    noop
    addx -36
    noop
    addx 1
    addx 7
    noop
    noop
    noop
    addx 2
    addx 6
    noop
    noop
    noop
    noop
    noop
    addx 1
    noop
    noop
    addx 7
    addx 1
    noop
    addx -13
    addx 13
    addx 7
    noop
    addx 1
    addx -33
    noop
    noop
    noop
    addx 2
    noop
    noop
    noop
    addx 8
    noop
    addx -1
    addx 2
    addx 1
    noop
    addx 17
    addx -9
    addx 1
    addx 1
    addx -3
    addx 11
    noop
    noop
    addx 1
    noop
    addx 1
    noop
    noop
    addx -13
    addx -19
    addx 1
    addx 3
    addx 26
    addx -30
    addx 12
    addx -1
    addx 3
    addx 1
    noop
    noop
    noop
    addx -9
    addx 18
    addx 1
    addx 2
    noop
    noop
    addx 9
    noop
    noop
    noop
    addx -1
    addx 2
    addx -37
    addx 1
    addx 3
    noop
    addx 15
    addx -21
    addx 22
    addx -6
    addx 1
    noop
    addx 2
    addx 1
    noop
    addx -10
    noop
    noop
    addx 20
    addx 1
    addx 2
    addx 2
    addx -6
    addx -11
    noop
    noop
    noop"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end
  
  def solve_first(input)
    lines = input.lines.map(&:strip)
    
    cycle = 0
    register = 1
    
    sig_cycles = [20, 60, 100, 140, 180, 220]
    readings = []
    
    for command in lines
      op, val = command.split
      
      case op
      when 'noop'
        cycle += 1
        readings << register * cycle if sig_cycles.include? cycle
      when 'addx'
        cycle += 1
        readings << register * cycle if sig_cycles.include? cycle
        cycle += 1
        readings << register * cycle if sig_cycles.include? cycle
        register += val.to_i
      end
    end
    
    readings.sum
  end
  
  def update_screen_pixel(cycle, register)
    output = ''
    pos = (cycle - 1) % 40
    diff = (register - pos).abs
    output << (diff > 1 ? '.' : '#')
    output << "\n" if pos == 39
    output
  end

  def solve_second(input)
    lines = input.lines.map(&:strip)
    
    cycle = 0
    register = 1
    
    screen = ''
    
    for command in lines
      op, val = command.split
      
      case op
      when 'noop'
        cycle += 1
        screen << update_screen_pixel(cycle, register)
      when 'addx'
        cycle += 1
        screen << update_screen_pixel(cycle, register)
        cycle += 1
        screen << update_screen_pixel(cycle, register)
        register += val.to_i
      end
    end
    
    puts screen
    'have a look at the output'
  end
end

s = Solver.new(day = 10)
# s.decipher
s.test_case
