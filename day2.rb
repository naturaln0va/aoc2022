# This script was written for the advent of code 2022 day 2.
# https://adventofcode.com/2022/day/2

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
    # opponent
    # A - rock
    # B - paper
    # C - scissors
    # player
    # X - rock
    # Y - paper
    # Z - scissors
    
    test_input = "A Y
    B X
    C Z"
    
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end

  def solve_first(input)
    answer = 0
    
    lines = input.lines.map(&:strip)
    
    input_mapping = { A: 'R', B: 'P', C: 'S', X: 'R', Y: 'P', Z: 'S' }
    score_mapping = { PR: 0, RP: 6, SP: 0, PS: 6, RS: 0, SR: 6 }
    input_score_mapping = { R: 1, P: 2, S: 3 }
    
    for line in lines
      choices = line.split.map { |v| input_mapping[v.to_sym] }
      opponent = choices.first
      player = choices.last
      # puts "They chose #{opponent} and you chose #{player}"
      line_score = 0
      if opponent == player
        line_score = 3
      else
        score_key = "#{opponent}#{player}".to_sym
        line_score = score_mapping[score_key]
      end
      answer += line_score + input_score_mapping[player.to_sym]
      line_score = 0
    end

    answer
  end

  def solve_second(input)
    answer = 0

    lines = input.lines.map(&:strip)
    
    action_mapping = { X: 'L', Y: 'D', Z: 'W'}
    input_mapping = { A: 'R', B: 'P', C: 'S', X: 'R', Y: 'P', Z: 'S' }
    input_action_mapping = { RL: 'S', RD: 'R', RW: 'P', PL: 'R', PD: 'P', PW: 'S', SL: 'P', SD: 'S', SW: 'R' }
    score_mapping = { PR: 0, RP: 6, SP: 0, PS: 6, RS: 0, SR: 6 }
    input_score_mapping = { R: 1, P: 2, S: 3 }
    
    for line in lines
      opponent = input_mapping[line.split.first.to_sym]
      action = action_mapping[line.split.last.to_sym]
      player_key = "#{opponent}#{action}".to_sym
      player = input_action_mapping[player_key]
      # puts "They chose #{opponent} and you need to #{action}, so the player must be #{player}"
      line_score = 0
      if opponent == player
        line_score = 3
      else
        score_key = "#{opponent}#{player}".to_sym
        line_score = score_mapping[score_key]
      end
      answer += line_score + input_score_mapping[player.to_sym]
      line_score = 0
    end

    answer
  end
end

s = Solver.new(day = 2, year = 2022)
# s.decipher
s.test_case
