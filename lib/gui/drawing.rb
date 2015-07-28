module Drawing
  def fill_rect(x, y, width, height, color, z = 0, mode = :default)
    return $window.draw_quad(x, y, color,
                             x, height+y, color,
                             width+x, height+y, color,
                             width+x, y, color,
                             z, mode)
  end
end
