module Rrobots
  class PlayerRegistry
    def initialize(socket)
      @players = {}
      @socket = socket
    end

    def handle_packet(packet)
      msg, (_, from_port, from_host, from_ip) = packet
      if match = /\AREG ([a-zA-Z]{1,20})\z/.match(msg)
        name = match[1]
        puts "\tregistered #{name}" if $debug
        @players[name] = Player.new(@socket, from_ip, from_port, name)
        @players[name].send("REGD")
      end
    end

    def random_players(n)
      return false if @players.size < n
      # TODO ping players to make sure they are still around?
      @players.values.shuffle.slice(0..n)
    end
  end

  class Player
    attr_reader :name

    def initialize(socket, from_ip, from_port, name)
      @socket = socket
      @from_port = from_port
      @from_ip = from_ip
      @name = name
      puts "\t#{name} => #{from_ip}:#{from_port}"
    end

    def send(msg)
      @socket.send(msg, 0, @from_ip, @from_port)
    end
  end
end
