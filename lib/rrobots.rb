require 'rrobots/robot'
require 'rrobots/battlefield'
require 'rrobots/explosion'
require 'rrobots/bullet'
require 'rrobots/robot_runner'
require 'rrobots/numeric'

# networked code
require "rrobots/player_registry"
require "rrobots/networked_game"

module Rrobots
  def self.receive_all_waiting_packets(socket)
    loop do
      packet = socket.recvfrom_nonblock(512)
      p packet if $debug
      yield packet
    end
  rescue IO::EAGAINWaitReadable
    true
  end
end
