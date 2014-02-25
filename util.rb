require 'colored'

class Util
  def self.space2coord space
    [8 - space[1].chr.to_i, space.downcase[0] - 'a'[0]]
  end
  def self.coord2space coord
    "#{('a'[0] + coord[1]).chr}#{8 - coord[0]}"
  end
  def self.valid_coord? coord
    coord.all?{|n| n <= 7 and n >= 0}
  end
  def self.color_for_space space
    rank, file = Util.space2coord(space)
    if (rank + file).even? then :white else :black end
  end
  def self.color text, color
    case color
    when :white then text.black_on_white
    when :black then text.white_on_black
    when :border then text.black_on_cyan
    end
  end
end
