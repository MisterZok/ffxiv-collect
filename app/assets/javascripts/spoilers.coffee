$ ->
  $('#hide-spoilers').change ->
    $('.solution > span').toggleClass('spoiler', this.checked)
