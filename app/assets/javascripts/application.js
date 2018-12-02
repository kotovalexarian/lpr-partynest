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
    title: false,
    navbar: false,
    toolbar: {
      zoomIn: true,
      zoomOut: true,
      oneToOne: true,
      reset: true,
      prev: false,
      play: false,
      next: false,
      rotateLeft: true,
      rotateRight: true,
      flipHorizontal: true,
      flipVertical: true,
    },
  })
})
