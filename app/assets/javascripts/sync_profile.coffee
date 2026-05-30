$ ->
  return unless $('.sync-profile').length

  # Disable refresh on click to avoid multiple submissions
  $('.sync-profile').click ->
    $(this).addClass('disabled')
    $(this).blur()
