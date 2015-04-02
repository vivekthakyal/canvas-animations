class @Point
  constructor: (@x, @y, @color) ->

class @ParaboliodAnimation
  constructor: (id) ->
    canvas = document.getElementById(id)
    canvas.width = canvas.height = canvas.clientWidth
    @ctx = canvas.getContext('2d')
    @bounds = new Point(canvas.width, canvas.height)

    @tX = @bounds.x / 2
    @tY = @bounds.y / 2

    @points = []
    for y in [0..canvas.height] by 50
      for x in [0..canvas.width] by 50
        @points.push(new Point(x + ((y / 50) % 2) * 25, y, Color.random()))

    self = this
    $('#' + id).mousemove((e) ->
      offset = $(this).offset()
      x = e.pageX - offset.left
      y = e.pageY - offset.top
      requestAnimationFrame( ->
        self.translateOrigin(new Point(x, y))
        self.draw()
      )
    )

  scaledRadius: (x, y, radius) ->
      radius * (-1.5 * (sqr(1.5 * (x - @tX) / @bounds.x) + sqr(1.5 * (y - @tY) / @bounds.y)) + 1)

  draw: () ->
    @ctx.clearRect(0, 0, @bounds.x, @bounds.y)
    for point in @points
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

  translateOrigin: (point) ->
    @tX = point.x
    @tY = point.y

  sqr= (num) ->
    num * num
