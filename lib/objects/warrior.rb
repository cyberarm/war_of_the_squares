class Warrior < Square
  def setup
    self.health = 100
    self.max_health = 100
    @color = Gosu::Color::GREEN if   @friendly
    @color = Gosu::Color::RED unless @friendly
    @speed = 1
    @target=nil
    @target_tick=0
    @target_distance=nil
  end

  def draw
    fill_rect(@x-2, @y-2, 68, 68, Gosu::Color::BLACK)

    fill_rect(@x-64, @y-64, 172, 172, Gosu::Color.rgba(10,10,10,10))

    draw_line(@x+32, @y+32, @target.x+32, @target.y+32, 1, Gosu::Color::YELLOW, 101) if @target && @friendly
    draw_line(@x+32, @y+32, @target.x+32, @target.y+32, 1, Gosu::Color::BLACK,  101) if @target && !@friendly
    super
  end

  def update
    super
    targets = Square.all.find_all do |square|
      if square.friendly != self.friendly
        if square.x.between?(self.x-172, self.x+172)
          if square.y.between?(self.y-172, self.y+172)
            true
          end
        end
      end
    end

    target = nil
    distance= 172
    targets.each do |_target|
      _distance = Gosu.distance(self.x, self.y, _target.x, _target.y)
      if _distance < distance
        target = _target
        distance = _distance
      end
    end

    if @target == nil
      @target_tick=0
      @target_distance=nil

      base = Square.all.detect do |square|
        if square.friendly != self.friendly && square.is_a?(Base)
          true
        end
      end

      target = base
      @target = target
      @target_distance = Gosu.distance(self.x, self.y, @target.x, @target.y)
    else
      if target
        @target = target
        @target_distance = Gosu.distance(self.x, self.y, @target.x, @target.y)
      end
    end

    if @target
      @target_tick+=1
      move(@target.x, @target.y)
    end

    expiring_target
  end

  def expiring_target
    if @target_tick > 60
      if Gosu.distance(self.x, self.y, @target.x, @target.y) < @target_distance
        @target_distance = Gosu.distance(self.x, self.y, @target.x, @target.y)
      else
        @target = nil
      end
    end
  end
end
