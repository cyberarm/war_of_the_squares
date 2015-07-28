class Warrior < Square
  def setup
    self.health = 100
    @color = Gosu::Color::GREEN if   @friendly
    @color = Gosu::Color::RED unless @friendly
    @speed = 1
    @target=nil
  end

  def draw
    fill_rect(@x-2, @y-2, 68, 68, Gosu::Color::BLACK)

    fill_rect(@x-64, @y-64, 172, 172, Gosu::Color.rgba(10,10,10,10))

    $window.draw_line(@x+32, @y+32, Gosu::Color::YELLOW, @target.x+32, @target.y+32, Gosu::Color::YELLOW) if @target && @friendly
    $window.draw_line(@x+32, @y+32, Gosu::Color::BLACK, @target.x+32, @target.y+32, Gosu::Color::BLACK) if @target && !@friendly
    super
  end

  def update
    super
    die?
    target = Square.all.detect do |square|
      if square.friendly != self.friendly
        if square.x.between?(self.x-172, self.x+172)
          if square.y.between?(self.y-172, self.y+172)
            true
          end
        end
      end
    end

    if @target == nil
      base = Square.all.detect do |square|
        if square.friendly != self.friendly && square.is_a?(Base)
          true
        end
      end

      target = base
      @target = target
    else
      @target = target if target
    end

    if @target
      move(@target.x, @target.y)
    end

    attack
  end

  def attack
  end
end
