require 'optparse'
require 'ostruct'

module RRobots
  class OptionsParser
    def self.parse!(args)
      options = OpenStruct.new
      options.width = 1600
      options.height = 1024
      options.timeout = 10_800 # ~3min
      options.min_players = 3
      options.max_players = 6

      o = OptionParser.new do |opts|
        opts.banner = "Usage: server [options]"

        opts.on("--resolution x,y", Array, "X and Y resolution") do |resolution|
          options.width = resolution.map(&:to_i).first
          options.height = resolution.map(&:to_i).last
        end

        opts.on("--timeout N", Integer, "Maximum number of ticks for a match") do |n|
          options.timeout = n
        end

        opts.on("--min-players N", Integer, "Minimum number of players for a game to start") do |n|
          options.min_players = n
        end

        opts.on("--max-players N", Integer, "Maximum number of players in a game") do |n|
          options.max_players = n
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end

      o.parse!(args)

      return options
    end
  end
end
