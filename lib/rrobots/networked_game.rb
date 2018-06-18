require "rrobots/gui"

module Rrobots
  class NetworkedGame
    def self.run
      players = $registry.random_players($players_per_game)
      return false unless players
      puts "== START GAME"
      battlefield = setup_battlefield(players)
      run_in_gui(battlefield)
    end

    def self.setup_battlefield(players)
      seed = Time.now.to_i + Process.pid
      battlefield = Battlefield.new($game_width*2, $game_height*2, $timeout, seed)
      players.each_with_index do |player, index|
        robot = RobotRunner.new(Robot.new(player), battlefield, index)
        battlefield << robot
      end
      battlefield
    end

    def self.run_in_gui(battlefield)
      window = RRobotsGameWindow.new(battlefield, $game_width, $game_height)
      ticks_after_game_over = 60 * 5 # let the game run for 5 sec after it's over
      window.on_game_over do |battlefield|
        if ticks_after_game_over <= 0
          puts "== GAME OVER"
          window.close
        end
        ticks_after_game_over -= 1
      end
      window.show
    end
  end
end
