<!DOCTYPE html>
<html lang="en">
<?php snippet('head') ?>
<body id="company">
    <?php snippet('header') ?>

    <main>
        <div class="container-fluid contact">
            <div class="row justify-content-center">
                <div class="col-12 col-sm-7">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <?php snippet('footer') ?>
    <script src="../assets/js/main.min.js"></script>
</body>
</html>
