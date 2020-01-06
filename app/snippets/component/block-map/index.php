<div class="snippet" is="block-map">
  <div class="container">
    <div id="map"></div>
  </div>
  <?php $geo = $page->location_data()->yaml(); ?>
  <?= "<script language=\"javascript\">
  var map;
  function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
      center: {
        lat: " . $geo['lat'] . ",
        lng: " . $geo['lon'] . "
      },
      zoom: 16,
      disableDefaultUI: true,
      gestureHandling: \"none\"
    });
  }
  </script>"
  ?>
  <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDp06-CNwgZLQCKHL7aOlg8xoCoW0qed5U&callback=initMap"></script>
</div>
