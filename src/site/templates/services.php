<!DOCTYPE html>
<html lang="en">
<?php snippet('head') ?>
<body id="services">
    <?php snippet('header') ?>

    <main>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-12 col-sm-10">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                    <?php snippet('submenu') ?>
                </div>
            </div>
        </div>
    </main>

    <?php snippet('footer') ?>
</body>
<script src="../assets/js/main.min.js"></script>
</html>
