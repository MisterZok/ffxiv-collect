$(document).on 'turbolinks:load', ->
  return unless $('#verification').length
  new Clipboard('.clipboard')
