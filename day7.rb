# This script was written for the advent of code 2022 day 7.
# https://adventofcode.com/2022/day/7

require 'uri'
require 'net/http'

class FileDirectory
  attr_accessor :directories, :files, :name, :parent_path

  def initialize(n, p = [])
    @name = n
    @parent_path = p
    @files = []
    @directories = []
  end
  
  def directory_at_path(path)
    fd = nil
    pp = []
    for part in path
      if part == @name and @parent_path == pp
        fd = self
      else
        fd = fd.directories.select { |d| d.name == part and d.parent_path == pp }.first
      end
      pp << part
    end
    fd
  end
  
  def append_file(path, file)
    fd = directory_at_path(path)
    unless fd.nil?
      fd.files << file
    end
  end
  
  def append_directory(path, name)
    fd = directory_at_path(path)
    unless fd.nil?
      fd.directories << FileDirectory.new(name, path)
    end
  end
  
  def total
    @files.sum + @directories.map(&:total).sum
  end
  
  def rec_totals(h)
    key = (parent_path + [name]).join "-"
    h[key] = total
    @directories.each do |d|
      d.rec_totals(h)
    end
  end
end

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
    test_input = "$ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k"
    first_answer = solve_first(test_input)
    puts "the first test answer is: #{first_answer}"
    second_answer = solve_second(test_input)
    puts "the second test answer is: #{second_answer}"
  end
  
  def build_filesystem(input)
    lines = input.lines.map(&:strip)
    
    fd = nil
    full_path = []
    change_prefix = "$ cd "
    
    for line in lines
      if line.start_with? "$"
        if line.start_with? change_prefix
          path = line.delete_prefix change_prefix
          if path == ".."
            full_path.pop
          else
            if fd.nil?
              fd = FileDirectory.new(path)
            end
            full_path.append path
          end
        end
      else
        if line.start_with? "dir"
          directory_name = line.split.last
          fd.append_directory(full_path.clone, directory_name)
        else
          file_size = line.split.first.to_i
          fd.append_file(full_path.clone, file_size)
        end
      end
    end
    
    fd
  end

  def solve_first(input)
    fd = build_filesystem(input)
    
    totals = Hash.new
    fd.rec_totals(totals)
    
    target_max = 100000
    totals.values.filter { |v| v <= target_max }.sum
  end

  def solve_second(input)
    fd = build_filesystem(input)
    
    total_disk_size = 70000000
    space_required_for_update = 30000000
    
    current_free_space = total_disk_size - fd.total
    min_size_to_remove = space_required_for_update - current_free_space
    
    totals = Hash.new
    fd.rec_totals(totals)
    
    totals.values.filter { |v| v >= min_size_to_remove }.min
  end
end

s = Solver.new(day = 7)
# s.decipher
s.test_case
