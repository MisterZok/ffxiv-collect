$ ->
  return unless $('.armors').length

  buttons = $('.category-buttons button')
  buttons.click ->
    category = $(@).attr('id').match(/\d+$/)[0]
    buttons.removeClass('active')
    $(@).addClass('active')

    $('.armors').addClass('hidden')
    $(".armors.category-#{category}").removeClass('hidden')
