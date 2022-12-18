# This script was written for the advent of code 2022 day 17.
# https://adventofcode.com/2022/day/17

require 'set'
require 'uri'
require 'net/http'

class Solver
  attr_accessor :grid
  
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
    test_input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
    first_answer = solve_first(test_input, 2022)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input, 1_000_000_000_000)
    puts "the second test answer is: #{second_answer}"
  end
  
  def move_shape(shape, x, y)
    new_shape = shape.dup
    
    for i in (0...shape.length)
      p = new_shape[i].dup
      p[0] = p[0] + x
      p[1] = p[1] + y
      
      new_shape[i] = p
    end
    
    # for point in shape
    #   new_shape << [point.first + x, point.last + y]
    # end
    
    new_shape
  end
  
  def check_shape(shape, grid, width)
    for point in shape
      px = point.first
      py = point.last
      return false if px >= width or px < 0 or py < 0 or grid.include?(point)
    end
    true
  end

  def simulate_rocks(input, steps)
    directions = input.split('').map { |d| d == '>' ? 1 : -1 }
    
    shapes = []
    shapes << [[0, 0], [1, 0], [2, 0], [3, 0]]
    shapes << [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]]
    shapes << [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]]
    shapes << [[0, 0], [0, 1], [0, 2], [0, 3]]
    shapes << [[0, 0], [1, 0], [0, 1], [1, 1]]
    
    grid = Set.new
    
    floor = 0
    width = 7
    spawn_x = 2
    shape_index = 0
    direction_index = 0
    current_shape = nil
    should_push = true
    
    rocks_at_rest = 0
    
    while rocks_at_rest < steps
      if current_shape.nil?
        current_shape = shapes[shape_index].dup
        shape_index = (shape_index == shapes.length - 1) ? 0 : shape_index + 1
        current_shape = move_shape(current_shape, spawn_x, floor + 3)
        should_push = true
        puts "SPAWN"
      end
      
      if should_push
        dir = directions[direction_index]
        direction_index = (direction_index == directions.length - 1) ? 0 : direction_index + 1
        ms = move_shape(current_shape, dir, 0)
        puts "#{dir == 1 ? 'R' : 'L'} SHIFT"
        current_shape = ms if check_shape(ms, grid, width)
      else
        ms = move_shape(current_shape, 0, -1)
        puts "FALL"
        if check_shape(ms, grid, width)
          current_shape = ms
        else
          grid.merge current_shape
          shape_max = current_shape.map(&:last).max + 1
          floor = shape_max if shape_max > floor
          current_shape = nil
          rocks_at_rest += 1
          puts "REST, floor: #{floor}, at rest: #{rocks_at_rest}"
        end
      end
      should_push = !should_push
      
      p current_shape unless current_shape.nil?
    end
    
    @grid = grid
    floor
  end
  
  def solve_first(input, steps)
    simulate_rocks(input, steps)
  end

  def solve_second(input, steps)
    simulate_rocks(input, steps)
    # 0
  end
end

s = Solver.new(day = 17)
# s.decipher
s.test_case

# 2940 - too low

return

require 'ruby2d'

tile_size = 25
tw = 15
width = tile_size * tw
height = tile_size * 39

# Define some window properties
set title: "AOC Day 17"
set width: width, height: height

for point in s.grid
  # Create a new shape
  s = Square.new(
    x: (point.first + ((tw - 7) / 2)) * tile_size, 
    y: height - ((point.last + 1) * tile_size), 
    size: tile_size
  )
end

# Show the window
show
