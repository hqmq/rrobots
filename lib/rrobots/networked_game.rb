module Rrobots
  class NetworkedGame
    def self.run(socket, registry, number_of_players)
      players = registry.random_players(number_of_players)
      return false unless players
      game = new(socket, registry, players)
    end

    def initialize(socket, registry, players)
      @socket = socket
      @registry = registry
      @players = players
      puts "\tSTARTING GAME: #{players.map(&:name).join(", ")}"
    end
  end
end
