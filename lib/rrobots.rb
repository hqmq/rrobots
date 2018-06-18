require 'rrobots/robot'
require 'rrobots/battlefield'
require 'rrobots/explosion'
require 'rrobots/bullet'
require 'rrobots/robot_runner'
require 'rrobots/numeric'
require 'rrobots/option_parser'

# networked code
require "rrobots/player_registry"
require "rrobots/networked_game"

module Rrobots
  def self.receive_all_up_to(total_wait_time, poll_interval = 0.001, &block)
    start = Time.now
    loop do
      receive_all_waiting_packets(&block)
      break if (Time.now - start) > total_wait_time
      sleep poll_interval
    end
  end

  def self.receive_all_waiting_packets
    loop do
      packet = $socket.recvfrom_nonblock(512)
      $registry.handle_packet(packet)
      p packet if $debug
      yield packet if block_given?
    end
  rescue IO::EAGAINWaitReadable
    true
  end
end
