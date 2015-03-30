class @Point
  constructor: (@x, @y, @color) ->

class @ParabolliodAnimation
  constructor: (@bounds, @dropOffFactor, @ctx) ->
    @tX = @bounds.x / 2
    @tY = @bounds.y / 2
    @scaledRadius = (x, y, radius) ->
      radius / ((sqr(x - @tX) + sqr(y - @tY)) / @dropOffFactor + 1)

  drawPoints: (points) ->
    @ctx.clearRect(0, 0, @bounds.x, @bounds.y)
    for point in points
      @ctx.fillStyle = point.color
      @ctx.beginPath()
      @ctx.moveTo(point.x, point.y)
      @ctx.arc(point.x, point.y, @scaledRadius(point.x, point.y, 25), 0, 2 * Math.PI)
      @ctx.fill()

  translate: (point) ->
    @tX = point.x
    @tY = point.y

  sqr= (num) ->
    num * num
