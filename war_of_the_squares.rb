require "etc"
require "gosu"
require "securerandom"
SecureRandom.random_number(100) # Prep, I guess?

require_relative "lib/gui/font"
require_relative "lib/gui/drawing"

require_relative "lib/square"
require_relative "lib/objects/base"
require_relative "lib/objects/warrior"

class Frame < Gosu::Window
  include Drawing
  attr_accessor :post_game, :game_time

  def initialize
    super(Gosu.screen_width, Gosu.screen_height, true)

    if self.width < 1280 && self.height < 720
      puts "NOT IDEAL SCREEN RESOLUTION!"
      puts "Recommend at least 1280x720 (HD)."
    end

    self.caption = "War Of The Squares"
    @title = Text.new("War Of The Squares", font: "Wallpoet", size: 58, x: 10, color: Gosu::Color::BLACK)
    @fps = Text.new("", font: "Wallpoet", size: 14, x: 10, y: 45, color: Gosu::Color::BLACK)

    @post_game = Text.new("", font: "Wallpoet", size: 50, x: width/3, y: height/3, color: Gosu::Color::BLACK, z: 110)
    @game_time = Text.new("", font: "Wallpoet", size: 30, x: 100, y: height/3+55, color: Gosu::Color::BLACK, z: 110)

    @player = Base.new(100, 120, true)
    @enemy  = Base.new(width-500, 250, false)

    @locked = false
  end

  def draw
    fill_rect(0, 0, width, height, Gosu::Color::WHITE)

    Square.all.each(&:draw)

    @title.draw
    @fps.draw

    @post_game.draw
    @game_time.draw
  end

  def update
    exit if Gosu.button_down?(Gosu::KbEscape)
    Square.all.each(&:update)

    Square.all.each do |squareA|
      Square.all.each do |squareB|
        if squareA.friendly != squareB.friendly
          if squareA.x.between?(squareB.x-4, squareB.x+68)
            if squareA.y.between?(squareB.y-4, squareB.y+68)
              squareA.hit
              squareB.hit
            end
          end
        end
      end
    end

    if (@player.die? || @enemy.die?) && !@locked
      @locked = true

      if @player.die?
        @post_game.text = "#{Etc.getlogin} Lost!"
        @game_time.text = "Took #{Gosu.milliseconds/1000.0} seconds, and you took #{@player.max_health} of #{@player.max_health} damage (100%)"
      else
        @post_game.text = "#{Etc.getlogin} Won!"
        @game_time.text = "Took #{Gosu.milliseconds/1000.0} seconds, and you took #{@player.max_health - @player.health} of #{@player.max_health} damage (#{100-((@player.health.to_f / @player.max_health.to_f)*100.0).round(1)}%)"
      end
    end

    if Gosu.button_down?(Gosu::MsLeft)
      @player.target   = Place.new
      @player.target.x = mouse_x - 32
      @player.target.y = mouse_y - 32
    end

    @fps.text = "FPS: #{Gosu.fps}"
  end

  def needs_cursor?
    return true
  end

  def button_up(id)
    Square.all.each {|square| square.button_up(id) if defined?(square.button_up)}
  end
end

Frame.new.show unless defined?(Ocra)
