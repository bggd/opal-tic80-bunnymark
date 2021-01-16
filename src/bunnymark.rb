require 'opal'
require 'opal/tic80'

$SCREEN_WIDTH = 240
$SCREEN_HEIGHT = 136
$TOOLBAR_HEIGHT = 6
t = 0

class Bunny
  @@width = 16
  @@height = 16

  def initialize
    @x = rand 0..($SCREEN_WIDTH - @@width)
    @y = rand 0..($SCREEN_HEIGHT - @@height)
    @speed_x = rand(-100..100) / 60
    @speed_y = rand(-100..100) / 60
    @sprite = 1
  end

  def draw
    spr(@sprite, @x, @y, 14, 1, 0, 0, 2, 2)
  end

  def update
    @x += @speed_x
    @y += @speed_y

    if @x + @@width > $SCREEN_WIDTH
      @x = $SCREEN_WIDTH - @@width
      @speed_x *= -1
    end
    if @x < 0
      @x = 0
      @speed_x *= -1
    end
    if @y + @@height > $SCREEN_HEIGHT
      @y = $SCREEN_HEIGHT - @@height
      @speed_y *= -1
    end
    if @y < $TOOLBAR_HEIGHT
      @y = $TOOLBAR_HEIGHT
      @speed_y *= -1
    end
  end
end

class Fps
  def initialize
    @value = 0
    @frames = 0
    @last_time = 0
  end

  def get_value
    if time() - @last_time <= 1000
      @frames += 1
    else
      @value = @frames
      @frames = 0
      @last_time = time()
    end
    @value
  end
end

fps = Fps.new
bunnies = []
bunnies << Bunny.new

TIC do
  t += 1

  # Input
  if btn(0)
    5.times { bunnies << Bunny.new }
  elsif btn(1)
    5.times { bunnies.pop }
  end

  # Update
  bunnies.each { |i| i.update }

  # Draw
  cls(15)
  bunnies.each { |i| i.draw }

  rect(0, 0, $SCREEN_WIDTH, $TOOLBAR_HEIGHT, 0)
  print("Bunnies: #{bunnies.size}", 1, 0, 11, false, 1, false)
  print("FPS: #{fps.get_value}", $SCREEN_WIDTH / 2, 0, 11, false, 1, false)
end
