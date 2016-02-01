#!/usr/bin/env ruby
require 'dk_codebreaker'
require 'rainbow/ext/string'
require 'json'
require 'terminal-table'
  
  puts "Hello.Codebreaker is a logic game in which a code-breaker tries
to break a secret code created by a code-maker.The code-maker, which will
be played by the application we’re going to write, creates a secret code of
four numbers between 1 and 6.

Command word:
exit - for end game
stats - watch users stats".color(:yellow)

  puts "Please enter Your name for start:".color(:green)
  name = gets.chomp
  puts "Count of attempts".color(:green) 
  attempts = gets.chomp.to_i
  game = DkCodebreaker::Game.new(name,attempts)
  game.start

def save file = 'game.json', game
    begin
      file = File.open(file, "a")
      data = game.user_data
      file.puts(data.to_json) 
    rescue IOError => e
      puts "Can't save data into file".color(:red)
    ensure
      file.close unless file.nil?
    end
end


def view_stats file = 'game.json'
  if File.exist? file
      array = []
        File.open(file, "r") do |infile|
          while (line = infile.gets)
            array << JSON.parse(line)
          end
        end
      array
  end
end

def stats 
  table = Terminal::Table.new :headings => ['Name','Attempt','Limit','Time'], :rows => view_stats
  puts table
end

def restart game
  puts "You want save game result? Y/N"
  answer = gets.chomp
  case answer
  when /[Yy]/
    save game
  end
  puts "You want see game stats? Y/N"
  answer = gets.chomp
  case answer
  when /[Yy]/
    stats
  end
  puts "You want restart game? Y/N"
  answer = gets.chomp
  case answer
  when /[Yy]/
    game.restart
  when /[Nn]/
    exit
  end
end

loop do
  puts "Enter four number.Use command 'hint'.You use #{game.attempt} attempt from #{attempts}".color(:green)
  command = gets.chomp
  case command
  when "hint"
    unless game.hint_status
      puts game.hint.color(:magenta)
    else
      puts "You already use hint.".color(:aqua)
    end 
  when "exit"
    abort("Good Bye")
  when "stats"
    stats
  else
    submit = game.guess command
    case submit
    when :you_lose
      puts "You attempts have ended.You lose".color(:aqua)
      restart game
    when :less_then_four
      puts "Please enter 4 numbers".color(:red)
    when :code_not_string
      puts "Error.Code not string".color(:red)
    when :guess_has_symbol
      puts "Error.Code can't have a symbol only numbers".color(:red)
    when "++++"
      puts "YAHOO!!! YOU ARE WIN!!!".color(:silver)
      restart game
    when ""
      puts "not guess any numbers".color(:aqua)
    else
      puts submit.color(:aliceblue)               
    end
  end 
end