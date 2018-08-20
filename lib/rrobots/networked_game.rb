require "rrobots/gui"

module Rrobots
  class NetworkedGame
    def self.run
      $registry.prune_inactive_players
      players = $registry.random_players
      return false unless players
      puts "== START GAME"
      battlefield = setup_battlefield(players)
      run_in_gui(battlefield, players)
    end

    def self.setup_battlefield(players)
      seed = Time.now.to_i + Process.pid
      battlefield = Battlefield.new($options.width*2, $options.height*2, $options.timeout, seed)
      players.each_with_index do |player, index|
        robot = RobotRunner.new(Robot.new(player), battlefield, index)
        battlefield << robot
        player.send("START_GAME #{$options.width*2}x#{$options.height*2} #{robot.size}")
      end
      battlefield
    end

    def self.run_in_gui(battlefield, players)
      window = RRobotsGameWindow.new(battlefield, $options.width, $options.height)
      ticks_after_game_over = 60 * 5 # let the game run for 5 sec after it's over
      window.on_game_over do |battlefield|
        if ticks_after_game_over <= 0
          puts "== GAME OVER"
          window.close
        end
        ticks_after_game_over -= 1
      end
      window.show
      players.each{|player| player.send "GAME_OVER" }
    end
  end
end
