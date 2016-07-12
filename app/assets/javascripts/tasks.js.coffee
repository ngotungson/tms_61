ready = ->
  $('form').find('a').addClass('btn btn-primary');

  @add_fields = (link, association, content) ->
    new_id = (new Date).getTime()
    regexp = new RegExp('new_' + association, 'g')
    $('.new_task').before(content.replace(regexp, new_id))

  $(document).on 'click', 'form .remove_field', (event) ->
    $(@).prev('input[type=hidden]').val('1')
    $(@).parent().parent().hide()
    event.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)
