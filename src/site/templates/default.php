<!DOCTYPE html>
<html lang="en">
    <?php snippet('head') ?>
    <body>
        <?php snippet('header') ?>

        <main>
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="intro">
                            <p><?php echo $page->text() ?></p>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <?php snippet('footer') ?>
        <script src="./assets/js/jquery.min.js"></script>
        <script src="./assets/js/bootstrap.bundle.min.js"></script>
        <script src="./assets/js/main.min.js"></script>
    </body>
</html>
