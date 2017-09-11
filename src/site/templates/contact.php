<!DOCTYPE html>
<html lang="en">
<?php snippet('head') ?>
<body id="contact">
    <?php snippet('header') ?>

    <main>
        <div class="container-fluid contact">
            <div class="row justify-content-center">
                <div class="col-12 col-sm-8 col-md-9 col-lg-7">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                    <h2>Kontaktdaten</h2>
                    <div class="content">
                        <div class="row">
                            <div class="col-12 col-md-6">
                                <div class="contact-channel">
                                    <p>Tel:&nbsp;<?php echo $page->phone() ?></p>
                                    <p>Fax:&nbsp;<?php echo $page->fax() ?></p>
                                    <p><a href="mailto:<?php echo $page->email() ?>"><?php echo $page->email() ?></a></p>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <div class="contact-address">
                                    <p><?php echo $page->company() ?></p>
                                    <p><?php echo $page->street() ?></p>
                                    <p><?php echo $page->zip() ?>&nbsp;<?php echo $page->location() ?></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="gmap"></div>
            </div>
        </div>
    </main>

    <?php snippet('footer') ?>
    <!--build:js js/main.min.js -->
    <script src="../assets/js/main.min.js"></script>
    <!-- endbuild -->
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDp06-CNwgZLQCKHL7aOlg8xoCoW0qed5U&callback=initMap">
    </script>
</body>
</html>
