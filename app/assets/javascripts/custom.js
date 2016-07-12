$(document).on('ready page:load', function() {
  $('#flash-content').delay(5000).fadeOut(300)
  var current_tab = $('#courses-tab').attr('data-current-tab')
  $('#courses-tab a[href="#' + current_tab + '"]').tab('show')
});
