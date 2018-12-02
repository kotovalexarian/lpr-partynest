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
  $('#image').passportImageViewer()

  $("input[name='passport[images]']").change(function() {
    if (!this.files) { return }

    var file = this.files[0]

    if (!file) { return }

    var reader = new FileReader()

    reader.onload = function(e) {
      $('#image').attr('src', e.target.result)
      $('#image').passportImageViewer()
    }

    reader.readAsDataURL(file)
  })
})

$.fn.passportImageViewer = function() {
  $(this).viewer('destroy')

  $(this).viewer({
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
}
