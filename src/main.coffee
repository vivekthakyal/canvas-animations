$( ->
  canvas = document.getElementById('anim_1')
  canvas.width = canvas.height = $('#anim_1').width()

  randomColor = () ->
    '#' + (Math.random() * 0xFFFFFF << 0).toString(16)

  if canvas.getContext
    ctx = canvas.getContext('2d')
    anim = new ParaboliodAnimation(new Point(canvas.width, canvas.height), 50000, ctx)
    points = []
    for y in [0..canvas.height] by 50
      for x in [0..canvas.width] by 50
        points.push(new Point(x + ((y / 50) % 2) * 25, y, randomColor()))

    anim.drawPoints(points)

    $('#anim_1').mousemove((e) ->
      offset = $(this).offset()
      x = e.pageX - offset.left
      y = e.pageY - offset.top
      requestAnimationFrame( ->
        anim.translate(new Point(x, y))
        anim.drawPoints(points)
      )
    )
)
