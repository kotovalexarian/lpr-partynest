window.onload = function() {
  $('.progress').hide();
  var passportPreview = document.getElementById('passportPreview').src.trim();
  if (!passportPreview || !passportPreview.match(/(.jpg|.png|.gif)$/i)) {
    document.getElementById('passportMessage').style.display = 'inline-block';
    document.getElementById('passportMessage').innerText = 'Загрузите фото/скан-копию основной страницы пасспорта';
    document.getElementById('passportFileLabel').style.display = 'inline-block';
  } else {
    $('#passportPreview').wrap('<span style="display:inline-block"></span>').css('display', 'block').parent().zoom();
    document.getElementById('passportFileLabel').style.display = 'none';
    document.getElementById('passportMessage').style.display = 'none';
  }
};

function readURL(input) {
  var maxWidth = 1024;
  var maxHeight = 2048;
  var file = input.files[0];
  var imageType = /image.*/;
  if (file && file.type.match(imageType)) {
    document.getElementById('passportMessage').style.display = 'none';
    var reader = new FileReader();
    reader.onload = function(e) {
      var img = new Image();
      img.src = reader.result;
      img.onload = function() {
        document.getElementById('passportPreviewControls').style.display = 'inline-block';
        var $image = $('#passportPreview');
        $image.cropper('destroy').attr('src', this.src).cropper();
        document.getElementById('passportPreviewRotateLeft').addEventListener('click', function() {
          $image.cropper('rotate', -90);
        });
        document.getElementById('passportPreviewRotateRight').addEventListener('click', function() {
          $image.cropper('rotate', 90);
        });
        document.getElementById('passportPreviewZoomIn').addEventListener('click', function() {
          $image.cropper('zoom', 0.1);
        });
        document.getElementById('passportPreviewZoomOut').addEventListener('click', function() {
          $image.cropper('zoom', -0.1);
        });
        document.getElementById('passportPreviewSubmit').addEventListener('click', function() {
          this.disabled = true;
          var $progress = $('.progress');
          var $progressBar = $('.progress-bar');
          var canvas = $image.cropper('getCroppedCanvas');
          canvas.toBlob(function(blob) {
            var formData = new FormData();
            formData.append('passportFile', blob, file.name);
            $.ajax('passportUpload.php', {
              method: 'POST',
              data: formData,
              processData: false,
              contentType: false,
              xhr: function() {
                var xhr = new XMLHttpRequest();
                xhr.upload.onprogress = function(e) {
                  var percent = '0';
                  var percentage = '0%';
                  if (e.lengthComputable) {
                    percent = Math.round((e.loaded / e.total) * 100);
                    percentage = percent + '%';
                    $progressBar.width(percentage).attr('aria-valuenow', percent).text(percentage);
                  }
                };
                return xhr;
              },
              success: function() {
                console.log('Upload success');
              },
              error: function() {
                console.log('Upload error');
              },
              complete: function() {
                $progress.hide();
              },
            });
          });
        });
      };
    };
    reader.readAsDataURL(file);
  } else {
    document.getElementById('passportPreview').src = '';
    document.getElementById('passportMessage').style.display = 'block';
    document.getElementById('passportMessage').innerText = 'Неподдерживаемый формат файла!';
  }
}
