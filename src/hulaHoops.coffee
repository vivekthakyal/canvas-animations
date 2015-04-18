class Circle
  constructor: (@center, @radius) ->

class @Hoop
  constructor: (@radius, @innerCircle, startAngle, @angularVelocity) ->
    @angle = startAngle
    @color = Color.random()
    @updateCenter(startAngle, 0)

  updateCenter: (dt) ->
    @angle = (@angle + @angularVelocity * dt) % (2 * Math.PI)
    @x = @innerCircle.radius * Math.cos(@angle) + @innerCircle.center.x
    @y = @innerCircle.radius * Math.sin(@angle) + @innerCircle.center.y

class @HulaHoops
  constructor: (id, numHoops) ->
    @canvas = document.getElementById(id)
    @canvas.width = @canvas.height = @canvas.clientWidth
    @ctx = @canvas.getContext('2d')
    @center = new Point(@canvas.width / 2, @canvas.height / 2)
    @hoops = []
    @lastFrame = new Date().getTime()
    for i in [1..numHoops]
      r = rand(10, @canvas.width * 0.4)
      @hoops.push(new Hoop(r, new Circle(@center, rand(r / 4, r / 2)), rand(0, 2 * Math.PI), rand(0.001, 0.005)))
    @hoops.sort (a, b) -> b.radius - a.radius

    self = this
    $('#' + id).mousemove((e) ->
      offset = $(this).offset()
      x = e.pageX - offset.left
      y = e.pageY - offset.top
      self.movecenter(self.center, new Point(x, y), new Date().getTime(), 300)
    )
    $('#' + id).mouseleave((e) =>
      @movecenter(@center, new Point(@canvas.width / 2, @canvas.height / 2), new Date().getTime(), 300)
    )

  movecenter: (startPoint, endPoint, startTime, duration) ->
    t = new Date().getTime() - startTime
    return if t >= duration
    t /= duration
    t = Easing.easeInOutCubic(t)
    @center.x = startPoint.x + t * (endPoint.x - startPoint.x )
    @center.y = startPoint.y + t * (endPoint.y - startPoint.y )
    requestAnimationFrame(() =>
      @movecenter(startPoint, endPoint, startTime, duration)
    )

  draw: () ->
    now = new Date().getTime()
    dt = now - @lastFrame
    hoop.updateCenter(dt) for hoop in @hoops
    @lastFrame = now
    @ctx.clearRect(0, 0, 300, 300)
    @ctx.lineWidth = 10
    for hoop in @hoops
      @ctx.moveTo(hoop.x, hoop.y)
      @ctx.strokeStyle = hoop.color
      @ctx.beginPath()
      @ctx.arc(hoop.x, hoop.y, hoop.radius, 0, 2 * Math.PI)
      @ctx.stroke()
    requestAnimationFrame( => @draw())

  rand= (min, max) ->
    Math.random() * (max - min) + min
