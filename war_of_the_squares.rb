require "etc"
require "gosu"
require_relative "lib/gui/font"
require_relative "lib/gui/drawing"

require_relative "lib/object"
require_relative "lib/objects/base"
require_relative "lib/objects/warrior"

class Frame < Gosu::Window
  include Drawing
  attr_accessor :post_game, :game_time

  def initialize
    # super(700, 600, false)
    super(Gosu.screen_width, Gosu.screen_height, true)
    $window = self
    self.caption = "War Of The Squares (#{Gosu.language})"
    @title = Text.new("War Of The Squares", font: "Wallpoet", size: 58, x: 10, color: Gosu::Color::BLACK)
    @fps = Text.new("", font: "Wallpoet", size: 40, x: 10, y: 45, color: Gosu::Color::BLACK)

    @post_game = Text.new("", font: "Wallpoet", size: 50, x: $window.width/3, y: $window.height/3, color: Gosu::Color::BLACK, z: 110)
    @game_time = Text.new("", font: "Wallpoet", size: 40, x: $window.width/3, y: $window.height/3+55, color: Gosu::Color::BLACK, z: 110)

    Base.new(100, 120, true)
    Base.new($window.width-500, 250, false)
  end

  def draw
    fill_rect(0, 0, $window.width, $window.height, Gosu::Color::WHITE)

    Square.all.each(&:draw)

    @title.draw
    @fps.draw

    @post_game.draw
    @game_time.draw
  end

  def update
    exit if $window.button_down?(Gosu::KbEscape)
    Square.all.each(&:update)

    Square.all.each do |squareA|
      Square.all.each do |squareB|
        if squareA.friendly != squareB.friendly
          if squareA.x.between?(squareB.x, squareB.x+64)
            if squareA.y.between?(squareB.y, squareB.y+64)
              squareA.hit
              squareB.hit
            end
          end
        end
      end
    end

    @fps.text = "FPS: #{Gosu.fps}"
  end

  def needs_cursor?
    return true
  end
end

Frame.new.show
