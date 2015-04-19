class @Point
  constructor: (@x, @y, @color) ->

  toString: () -> "#{ @x }, #{ @y }"

class @ParaboliodAnimation
  constructor: (id) ->
    canvas = document.getElementById(id)
    canvas.width = canvas.clientWidth
    canvas.height = canvas.clientWidth
    @ctx = canvas.getContext('2d')
    @bounds = new Point(canvas.width, canvas.height)

    @origin = new Point(@bounds.x / 2, @bounds.y / 2)

    @points = []
    for y in [0..canvas.height] by 50
      for x in [0..canvas.width] by 50
        @points.push(new Point(x + ((y / 50) % 2) * 25, y, Color.random()))

    self = this
    $('#' + id).mousemove((e) ->
      offset = $(this).offset()
      x = e.pageX - offset.left
      y = e.pageY - offset.top
      self.moveOrigin(self.origin, new Point(x, y), new Date().getTime(), 300)
    )
    $('#' + id).mouseleave((e) =>
      @moveOrigin(@origin, new Point(@bounds.x / 2, @bounds.y / 2), new Date().getTime(), 300)
    )

  scaledRadius: (x, y, radius) ->
    denom = Math.min(@bounds.x, @bounds.y)
    radius * (-1.5 * (sqr(1.5 * (x - @origin.x) / denom) + sqr(1.5 * (y - @origin.y) / denom)) + 1)

  moveOrigin: (startPoint, endPoint, startTime, duration) ->
    t = new Date().getTime() - startTime
    return if t >= duration
    t /= duration
    t = Easing.easeInOutCubic(t)
    @origin.x = startPoint.x + t * (endPoint.x - startPoint.x )
    @origin.y = startPoint.y + t * (endPoint.y - startPoint.y )
    requestAnimationFrame(() =>
      @moveOrigin(startPoint, endPoint, startTime, duration)
      @draw()
    )

  draw: () ->
    @ctx.clearRect(0, 0, @bounds.x, @bounds.y)
    for point in @points
      @ctx.fillStyle = point.color
      @ctx.beginPath()
      @ctx.moveTo(point.x, point.y)
      r = @scaledRadius(point.x, point.y, 25)
      r = 0 if r < 0
      @ctx.arc(point.x, point.y, r, 0, 2 * Math.PI)
      @ctx.fill()

  sqr= (num) ->
    num * num
