//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require viewerjs/dist/viewer
//= require jquery-viewer/dist/jquery-viewer
//= require_tree .

$(document).ready(function() {
  $('#image').viewer({
    inline: true,
  })
})
