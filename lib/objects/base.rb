class Base < Square
  def setup
    # setup the mind...
    @color = Gosu::Color::BLACK if @friendly
    @color = Gosu::Color::BLUE unless @friendly
    @speed = 1

    @tick = 0
    @move_tick = 0
  end

  def draw
    super
    draw_line(@x + @half_size, @y + @half_size, @target.x + @half_size, @target.y + @half_size, 1, Gosu::Color::GREEN, 101) if @target && @friendly
  end

  def update
    @tick+=1
    @move_tick+=1

    super

    if @tick >= 100
      spawn_square
      @tick = 0
    end

    @target = nil if @target && !@friendly && self.x.between?(@target.x-4, @target.x+4) && self.y.between?(@target.y-4, @target.y+4)

    move(@target.x, @target.y) if @target

    if @move_tick >= 4*60 && !@friendly
      unless @target
        @move_tick = 0
        @target   = Place.new(SecureRandom.random_number(Gosu.screen_width-70), SecureRandom.random_number(Gosu.screen_height-70))
      else
        @move_tick = 0
      end
    end
  end

  def spawn_square
    spawn = Square.all.detect { |square| square.friendly != self.friendly }
    Warrior.new(self.x, self.y, @friendly) if spawn
  end
end
