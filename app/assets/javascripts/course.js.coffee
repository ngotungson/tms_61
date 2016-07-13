ready = ->
  $('#flash-content').delay(5000).fadeOut 300
  $('.checkall').change ->
    $('input:checkbox').prop 'checked', $(this).prop('checked')

$(document).ready(ready)
$(document).on('page:load', ready)
