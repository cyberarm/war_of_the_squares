class Square
  include Drawing

  attr_accessor :x, :y, :z, :alpha, :color, :health, :friendly
  @@objects = []

  def initialize(x = 0, y = 0, friendly = false)
    @x = x
    @y = y
    @z = 0
    @alpha = 255
    @color = Gosu::Color::BLACK
    @health = 250
    @friendly = friendly

    @@objects << self

    @health_points = Text.new("#{@health}", size: 12, font: "", z: 100, color: Gosu::Color::BLACK)
    @health_points.text = "#{@health}"
    @health_points.x = self.x+20
    @health_points.y = self.y-33

    setup if defined?(self.setup)
  end

  def draw
    fill_rect(@x, @y, 64, 64, @color)

    # health
    fill_rect(@x, @y-36, (@health/100.0*64), 18, Gosu::Color.rgba(0, 255, 0, 180), 99) if @friendly
    fill_rect(@x, @y-36, (@health/100.0*64), 18, Gosu::Color.rgba(255, 0, 0, 180), 99) unless @friendly
    @health_points.draw
  end

  def update
    @health_points.text = "#{@health}"
    @health_points.x = self.x+20
    @health_points.y = self.y-33
  end

  def hit
    @health-=1
  end

  def die?
    if @health <= 0
      @@objects.delete(self)
      true
    else
      false
    end
  end

  def move(x, y)
    # http://stackoverflow.com/a/2625107/4664585
    dir_x = x - self.x
    dir_y = y - self.y

    hyp = Math.sqrt(dir_x*dir_x + dir_y*dir_y)
    dir_x /= hyp
    dir_y /= hyp

    self.x += dir_x*@speed
    self.y += dir_y*@speed
  end

  def self.all
    @@objects
  end
end
