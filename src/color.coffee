class @Color
  @random: () ->
    '#' + (Math.random() * 0xFFFFFF << 0).toString(16)