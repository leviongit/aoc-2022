class Slot
  def initialize(@x : Int32, @y : Int32, @value : Char)
    @visible = false
  end

  def edge?(size : {Int32, Int32}) : Bool
    @visible = (@x == 0) || (@y == 0) || (@x == size[0] - 1) || (@y == size[1] - 1)
  end

  def visible!
    @visible = true
  end

  def visible?
    @visible
  end

  def value
    @value
  end
end

data = File.read("in.txt").strip
lines = data.split('\n')
chars = lines.map(&.chars)
slots = chars.map_with_index { |ln, y|
  ln.map_with_index { |c, x|
    Slot.new(x, y, c).tap { |s|
      s.edge?({lines.size, lines.first.size})
    }
  }
}

transposed = slots.transpose

def p1
  ys = 1
  yl = slots.size - 1
  xl = slots.first.size - 1

  while ys < yl
    xs = 1
    while xs < xl
      sself = slots[ys][xs]
      left = slots[ys][0...xs]
      right = slots[ys][(xs + 1)..-1]
      up = transposed[xs][0...ys]
      down = transposed[xs][(ys + 1)..-1]
      sself.visible! if left.all? { |o| o.value < sself.value } ||
                        right.all? { |o| o.value < sself.value } ||
                        up.all? { |o| o.value < sself.value } ||
                        down.all? { |o| o.value < sself.value }

      # pp slots[ys][xs], left, right, up, down
      xs += 1
    end

    ys += 1
  end

  pp slots.flatten.select(&.visible?).size
end
