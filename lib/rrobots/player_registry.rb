module Rrobots
  class PlayerRegistry
    def initialize
      @players = {}
    end

    def handle_packet(packet)
      msg, (_, from_port, from_host, from_ip) = packet
      if msg == "ALIVE"
        key = [from_ip, from_port]
        player = @players[key]
        player.expired = false if player
      elsif match = /\AREG ([a-zA-Z\d]{1,20})\z/.match(msg)
        name = match[1]
        key = [from_ip, from_port]
        @players[key] = Player.new(from_ip, from_port, name)
        @players[key].send("REGD")
      end
    end

    def prune_inactive_players
      @players.each do |_key, player|
        player.expired = true
        player.send("ALIVE?")
      end
      Rrobots.receive_all_up_to(0.02)
      @players.reject!{|_key, player| player.expired }
    end

    def random_players
      return false if @players.size < $options.min_players
      n = [@players.size, $options.max_players].min
      @players.values.shuffle.slice(0..n)
    end
  end

  class Player
    attr_reader :name, :from_ip, :from_port
    attr_accessor :expired

    def initialize(from_ip, from_port, name)
      @from_port = from_port
      @from_ip = from_ip
      @name = name
      @expired = false
      puts "\tRegistered: #{name} => #{from_ip}:#{from_port}"
    end

    def send(msg)
      $socket.send(msg, 0, @from_ip, @from_port)
    end
  end
end
