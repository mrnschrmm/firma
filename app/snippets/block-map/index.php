<div class="snippet-component" is="block-map">
  <div class="container">
    <div id="map"></div>
  </div>
  <script>
    var map;

    function initMap() {
      map = new google.maps.Map(document.getElementById('map'), {
        center: {
          lat: 50.8723318,
          lng: 12.0732785
        },
        zoom: 16,
        disableDefaultUI: true,
        gestureHandling: "none"
      });
    }
  </script>
  <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDp06-CNwgZLQCKHL7aOlg8xoCoW0qed5U&callback=initMap"></script>
</div>
