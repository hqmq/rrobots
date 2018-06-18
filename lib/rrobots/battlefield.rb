# :stopdoc:
class Battlefield
  attr_reader :width
  attr_reader :height
  attr_reader :robots
  attr_reader :teams
  attr_reader :bullets
  attr_reader :explosions
  attr_reader :time
  attr_reader :seed
  attr_reader :timeout  # how many ticks the match can go before ending.
  attr_reader :game_over

  def initialize(width, height, timeout, seed)
    @width, @height = width, height
    @seed = seed
    @time = 0
    @robots = []
    @robots_by_source = {}
    @teams = Hash.new{|h,k| h[k] = [] }
    @bullets = []
    @explosions = []
    @timeout = timeout
    @game_over = false
    srand @seed
  end

  def << object
    case object
    when RobotRunner
      @robots << object
      @teams[object.team] << object
      player = object.robot.player
      key = [player.from_ip, player.from_port]
      @robots_by_source[key] = object
    when Bullet
      @bullets << object
    when Explosion
      @explosions << object
    end
  end

  def tick
    explosions.delete_if{|explosion| explosion.dead}
    explosions.each{|explosion| explosion.tick}

    bullets.delete_if{|bullet| bullet.dead}
    bullets.each{|bullet| bullet.tick}

    robots.each do |robot|
      robot.send :pre_tick unless robot.dead
    end

    Rrobots.receive_all_up_to(0.01) do |packet|
      _, from_port, _, from_ip = packet.last
      if robot = @robots_by_source[[from_ip, from_port]]
        robot.handle_packet(packet)
      end
    end

    robots.each do |robot|
      robot.send :post_tick unless robot.dead
    end

    @time += 1
    live_robots = robots.find_all{|robot| !robot.dead}
    @game_over = (  (@time >= timeout) or # timeout reached
                  (live_robots.length == 0) or # no robots alive, draw game
                  (live_robots.all?{|r| r.team == live_robots.first.team})) # all other teams are dead
    not @game_over
  end

  def state
    {:explosions => explosions.map{|e| e.state},
     :bullets    => bullets.map{|b| b.state},
     :robots     => robots.map{|r| r.state}}
  end

end
