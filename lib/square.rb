Place = Struct.new(:x, :y)

class Square
  include Drawing

  attr_accessor :x, :y, :z, :alpha, :color, :health, :max_health, :friendly, :target
  attr_reader :size, :half_size
  @@objects = []

  def initialize(x = 0, y = 0, friendly = false, size = 64)
    @x = x
    @y = y
    @z = 0
    @size = size
    @half_size = (size / 2.0).to_i
    @alpha = 255
    @color = Gosu::Color::BLACK
    @health = 250
    @max_health = 250
    @friendly = friendly

    @@objects << self

    @health_points = Text.new("#{@health}", size: 14, z: 100, color: Gosu::Color::BLACK)
    @health_points.text = "#{@health}"
    @health_points.x = self.x+20
    @health_points.y = self.y-33

    setup if defined?(self.setup)
  end

  def draw
    fill_rect(@x, @y, @size, @size, @color)

    # health
    health_bar(@health, @max_health, @x, @y - 36, @size, 18, Gosu::Color.rgba(0, 255, 0, 200), 99) if @friendly
    health_bar(@health, @max_health, @x, @y - 36, @size, 18, Gosu::Color.rgba(0, 255, 0, 200), 99) unless @friendly

    @health_points.draw
  end

  def update
    @health_points.text = "#{@health}"
    @health_points.x = self.x+20
    @health_points.y = self.y-33
    die?
  end

  def health_bar(value, max_value, x, y, width, height, color, z = 99)
    _width = (value / max_value.to_f) * width
    fill_rect(x, y, _width, 18, Gosu::Color.rgba(0, 0, 0, 180), z)
    fill_rect(x, y, _width, 18, color, z)
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
