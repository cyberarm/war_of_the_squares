module Drawing
  def fill_rect(x, y, width, height, color, z = 0, mode = :default)
    return $window.draw_quad(x, y, color,
                             x, height+y, color,
                             width+x, height+y, color,
                             width+x, y, color,
                             z, mode)
  end

  def fill_square(x, y, x2, y2, color, z = 0, mode = :default)
    return $window.draw_quad(x, y, color,
                             x2, y2, color,
                             x, y, color,
                             x2, y2, color,
                             z, mode)
  end

  def draw_line(x, y, x2, y2, width, color, z = 0, mode = :default)
    return $window.draw_quad(x, y, color,
                             x+width, y-width, color,
                             x2, y2, color,
                             x2+width, y2+width, color,
                             z, mode)
  end
end
