require "etc"
require "gosu"
require_relative "lib/gui/font"
require_relative "lib/gui/drawing"

require_relative "lib/object"
require_relative "lib/objects/base"
require_relative "lib/objects/warrior"

class Frame < Gosu::Window
  include Drawing

  def initialize
    # super(700, 600, false)
    super(Gosu.screen_width, Gosu.screen_height, true)
    $window = self
    self.caption = "War Of The Squares (#{Gosu.language})"
    @title = Text.new("War Of The Squares", font: "Wallpoet", size: 58, x: 10, color: Gosu::Color::BLACK)
    @fps = Text.new("", font: "Wallpoet", size: 40, x: 10, y: 45, color: Gosu::Color::BLACK)

    Base.new(100, 120, true)
    Base.new($window.width-500, 250, false)
  end

  def draw
    fill_rect(0, 0, $window.width, $window.height, Gosu::Color::WHITE)

    Square.all.each(&:draw)

    @title.draw
    @fps.draw
  end

  def update
    Square.all.each(&:update)

    Square.all.each do |squareA|
      Square.all.each do |square|
        if squareA.friendly != square.friendly
          if squareA.x.between?(square.x, square.x+64)
            if squareA.y.between?(square.y, square.y+64)
              squareA.hit
              square.hit
            end
          end
        end
      end
    end

    @fps.text = "FPS: #{Gosu.fps} - #{(Gosu.milliseconds/1000.0).round(1)} seconds"
  end

  def needs_cursor?
    return true
  end
end

Frame.new.show
