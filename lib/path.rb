class Node
  O_cost = 1000
  D_cost = 1414

  def initialize(x, y, sx, sy, tx, ty, w, h, g = 0, parent = nil)
    @x = x
    @y = y
    @sx = sx
    @sy = sy
    @tx = tx
    @ty = ty
    @w = w
    @h = h
    @g = g
    @parent = parent
  end

  attr_reader :x, :y
  attr_accessor :g, :parent

  def h
    dx = (@x - @tx).abs
    dy = (@y - @ty).abs

    if dy > dx then
      D_cost * dx + (O_cost * (dy - dx))
    else
      D_cost * dy + (O_cost * (dx - dy))
    end
  end

  def f
    g + h
  end

  def start?
    @x == @sx && @y == @sy
  end

  def target?
    @x == @tx && @y == @ty
  end

  def ==(oth)
    @x == oth.x && @y == oth.y
  end

  def neighbours
    ns = []
    ns << neighbour(@x-1, @y-1, true ) if @x > 0      && @y > 0
    ns << neighbour(@x-1, @y  , false) if @x > 0
    ns << neighbour(@x-1, @y+1, true ) if @x > 0      && @y < (@h-1)
    ns << neighbour(@x  , @y+1, false) if                @y < (@h-1)
    ns << neighbour(@x+1, @y+1, true ) if @x < (@w-1) && @y < (@h-1)
    ns << neighbour(@x+1, @y  , false) if @x < (@w-1)
    ns << neighbour(@x+1, @y-1, true ) if @x < (@w-1) && @y > 0
    ns << neighbour(@x  , @y-1, false) if                @y > 0
    ns
  end

  private
  def neighbour(x, y, d)
    Node.new(x, y, @sx, @sy, @tx, @ty, @w, @h, @g + (d ? D_cost : O_cost), self)
  end
end

class Path
  def initialize(maze)
    @maze = maze
    @path = []
    @pathvalid = false
  end

  def valid?
    @pathvalid
  end

  def generate_astar
    open = []
    closed = []

    open << Node.new(@maze.start[0], @maze.start[1],
                     @maze.start[0], @maze.start[1],
                     @maze.target[0], @maze.target[1],
                     @maze.width, @maze.height)
    loop do
      break if open.empty?

      open.sort! { |a, b| a.f <=> b.f }
      current = open.shift
      closed << current

      if current.target? then
        n = current.parent
        until n.start?
          @path.unshift([n.x, n.y])
          n = n.parent
        end
        @pathvalid = true
        break
      end

      current.neighbours.each do |n|
        next if !traversable(current.x, current.y, n.x, n.y) || closed.include?(n)

        if open.include?(n) then
          ni = open.index(n)
          m = open[ni]
          if n.f < m.f then
            m.g = n.g
            m.parent = current
          end
        else
          open << n unless open.include?(n)
        end
      end
    end

    self
  end

  def traversable(sx, sy, tx, ty)
    if sx == tx || sy == ty then
      @maze.walkable(tx, ty)
    else
      @maze.walkable(tx, ty) &&
      (@maze.walkable(sx, ty) || @maze.walkable(tx, sy))
    end
  end

  def pml
    @path.map{|p|p.join(" ")}.join("\n")
  end
end
