class @Bubble
  @MAX_R = 20
  @MAX_V = 0.02
  @GROWTH_RATE = 0.00005
  constructor: (@x, @y, @r, @createdAt) ->

  merge: (that) ->
    if this.r < that.r
      return that.merge(this)
    else
      newArea = this.area() + that.area()
      newR = Math.sqrt(newArea / Math.PI)
      newX = this.x + (this.x - that.x) * that.r / (this.r + that.r)
      newY = this.y + (this.y - that.y) * that.r / (this.r + that.r)
      return new Bubble(newX, newY, newR)

  touching: (that) ->
    dx = this.x - that.x
    dy = this.y - that.y
    sr = this.r + that.r
    (dx * dx + dy * dy) <= (dr * dr)

  velocity: () ->
    @r / 20 * Bubble.MAX_V

  grow: (now) ->
    if not @rising and @r <= Bubble.MAX_R
      @r += Bubble.GROWTH_RATE * (now - @createdAt)

  move: (now) ->
    if @rising
      @y -= (now - @startedRisingAt) * @velocity()

  rise: () ->
    if not @rising and @r > 2
      @rising = Math.random() < 0.2 * (@r / Bubble.MAX_R)
      if @rising
        @startedRisingAt = new Date().getTime()

class @RisingBubbles
  constructor: (id, @maxBubbles) ->
    @canvas = document.getElementById(id)
    elem = $('#' + id)
    elem.css('background-color', 'red')
    elem.click( =>
      ts = new Date().getTime()
      for b in @bubbles
        if not b.rising
          b.rising = true
          b.startedRisingAt = ts
    )

    @canvas.width = @canvas.clientWidth
    @canvas.height = @canvas.clientHeight
    @ctx = @canvas.getContext('2d')
    @ctx.fillStyle = '#FFFFFF'
    @bubbles = []
    @lastFrame = new Date().getTime()
    for i in [1..randInt(0, @maxBubbles)]
      @bubbles.push(new Bubble(randInt(0, @canvas.width), randInt(0, @canvas.height), rand(0, Bubble.MAX_R), new Date().getTime()))

  draw: () ->
    @run(new Date().getTime())

  run: (now) ->
    @update(now)
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    for bubble in @bubbles
      @ctx.moveTo(bubble.x, bubble.y)
      @ctx.beginPath()
      @ctx.arc(bubble.x, bubble.y, bubble.r, 0, 2 * Math.PI)
      @ctx.fill()
    requestAnimationFrame( => @run(new Date().getTime()))

  update: (now) ->
    for b in @bubbles
      b.grow(now)
      b.rise()
      b.move(now)
    @bubbles = (b for b in @bubbles when b.y + b.r >= 0)
    if @maxBubbles - @bubbles.length > 0
      for i in [1..(randInt(0, @maxBubbles - @bubbles.length))]
        @bubbles.push(new Bubble(randInt(0, @canvas.width), randInt(0, @canvas.height), 1, new Date().getTime()))

  randInt= (min, max) ->
    Math.floor(Math.random() * (max - min) + min)

  rand= (min, max) ->
    Math.floor(Math.random() * (max - min) + min)