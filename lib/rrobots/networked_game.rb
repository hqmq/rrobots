module Rrobots
  class NetworkedGame
    def self.run(socket, registry, num_players, width, height, timeout)
      players = registry.random_players(number_of_players)
      return false unless players
      game = new(socket, registry, players, width, height, timeout)
    end

    def initialize(socket, registry, players)
      @socket = socket
      @registry = registry
      @players = players
      puts "\tSTARTING GAME: #{players.map(&:name).join(", ")}"
    end
  end
end
