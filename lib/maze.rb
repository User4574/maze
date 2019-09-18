class Maze
  def initialize(w, h, sx = 0, sy = 0, tx = 0, ty = 0)
    @width = w
    @height = h
    @start = [sx, sy]
    @target = [tx, ty]
    @blocks = []
  end

  attr_reader :width, :height, :start, :target

  def generate_random(t = -1)
    @start = [rand(@width), rand(@height)]
    @target = [rand(@width), rand(@height)]

    t = rand(100) if t == -1
    t.times do
      x = rand(@width)
      y = rand(@height)
      w = [rand(5), @width - x].min
      h = [rand(5), @height - y].min
      @blocks << [x, y, w, h]
    end

    @blocks.reject! do |blk|
      sx = @start[0]
      sy = @start[1]
      tx = @target[0]
      ty = @target[1]
      bx1 = blk[0]
      by1 = blk[1]
      bx2 = blk[0] + blk[2]
      by2 = blk[1] + blk[3]

      sx >= bx1 && sx < bx2 && sy >= by1 && sy < by2 ||
      tx >= bx1 && tx < bx2 && ty >= by1 && ty < by2
    end

    self
  end

  def blocked(x, y)
    @blocks.any? do |blk|
      bx1 = blk[0]
      by1 = blk[1]
      bx2 = blk[0] + blk[2]
      by2 = blk[1] + blk[3]

      x >= bx1 && x < bx2 && y >= by1 && y < by2
    end
  end

  def walkable(x,y)
    !blocked(x,y)
  end

  def mml
    "#{@width} #{@height}\n" +
      "#{@start[0]} #{@start[1]}\n" +
      "#{@target[0]} #{@target[1]}\n" +
      @blocks.map{|b| b.join(" ")}.join("\n")
  end
end
