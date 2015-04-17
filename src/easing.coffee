class @Easing
  @easeOutCubic: (t) ->
    4*t*t*t

  @easeInOutCubic: (t) ->
    if t < .5
      4*t*t*t
    else (t-1)*(2*t-2)*(2*t-2)+1
