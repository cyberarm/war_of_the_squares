class Base < Square
  Place = Struct.new(:x, :y)
  def setup
    # setup the mind...
    @color = Gosu::Color::BLACK if @friendly
    @color = Gosu::Color::BLUE unless @friendly
    @speed = 1

    @tick = 0
    @move_tick = 0
  end

  def update
    @tick+=1
    @move_tick+=1

    super
     if die?
       puts "#{Etc.getlogin} Won!" if !@friendly
       puts "#{Etc.getlogin} Lost!" if @friendly
       puts "Took #{Gosu.milliseconds/1000.0} seconds."
       exit
     end

    if @tick >= 80#41
      spawn_square
      @tick = 0
    end

    if $window.button_down?(Gosu::MsLeft) && @friendly
      @target   = Place.new
      @target.x = $window.mouse_x-32
      @target.y = $window.mouse_y-32
    end

    @target = nil if @target && self.x == @target.x && self.y == @target.y

    move(@target.x, @target.y) if @target

    if @move_tick >= 4*60 && !@friendly && !@target
      @move_tick = 0
      @target   = Place.new(rand(Gosu.screen_width-70), rand(Gosu.screen_height-70))
    end
  end

  def spawn_square
    Warrior.new(self.x, self.y, @friendly)
  end
end
