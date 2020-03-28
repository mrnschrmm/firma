<div class="snippet" is="block-map">
    <script class='jsData' type='application/json'><?php
        $data = $page->location_data()->yaml();
        $geo[] = ['lat' => $data['lat'], 'lon' => $data['lon']];
        echo json_encode($geo);?>
    </script>
    <div class="container">
        <div id="map"></div>
    </div>
</div>
