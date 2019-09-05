class Text
  attr_accessor :x, :y, :z, :factor_x, :factor_y, :color, :options
  attr_reader :text, :height, :size, :font, :alpha

  def initialize(text, options)
    @text = text
    @options = options

    @options[:x] ||= 0
    @options[:y] ||= 0
    @options[:z] ||= 11

    @options[:factor_x] ||= 1.0
    @options[:factor_y] ||= 1.0

    @options[:color] ||= Gosu::Color.rgba(255,255,255,255)
    @options[:alpha] ||= @options[:color].alpha
    @options[:size]  ||= 13
    @options[:font]  ||= Gosu.default_font_name

    @x = @options[:x]
    @y = @options[:y]
    @z = @options[:z]

    @factor_x = @options[:factor_x]
    @factor_y = @options[:factor_y]

    @color = @options[:color]
    @alpha = @options[:alpha]
    # @color.alpha = @options[:alpha]
    @size  = @options[:size]

    @font = Gosu::Font.new(@options[:size], name: @options[:font])

    @height = @font.height
  end

  def draw
    @font.draw_text(@text, @x, @y, @z, @factor_x, @factor_y, @color)
  end

  def width
    return @font.text_width(@text, @factor_x)
  end

  def text=string
    @width = @font.text_width(string, @factor_x)
    @text  = string
  end

  def alpha=integer
    @color.alpha = integer
  end
end
