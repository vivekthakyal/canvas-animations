class @Point
  constructor: (@x, @y, @color) ->

class @ParaboliodAnimation
  constructor: (@bounds, @dropOffFactor, @ctx) ->
    @tX = @bounds.x / 2
    @tY = @bounds.y / 2
    @scaledRadius = (x, y, radius) ->
      radius * (-1.5 * (sqr(1.5 * (x - @tX) / @bounds.x) + sqr(1.5 * (y - @tY) / @bounds.y)) + 1)

  drawPoints: (points) ->
    @ctx.clearRect(0, 0, @bounds.x, @bounds.y)
    for point in points
      @ctx.fillStyle = point.color
      @ctx.lineWidth = 3
      @ctx.strokeStyle = '#FFFFFF'
      @ctx.beginPath()
      @ctx.moveTo(point.x, point.y)
      r = @scaledRadius(point.x, point.y, 25)
      r = 0 if r < 0
      @ctx.arc(point.x, point.y, r, 0, 2 * Math.PI)
      # @ctx.stroke()
      @ctx.fill()

  translate: (point) ->
    @tX = point.x
    @tY = point.y

  sqr= (num) ->
    num * num
