<!DOCTYPE html>
<html lang="en">
    <?php snippet('head') ?>
    <body id="service">
        <?php snippet('header') ?>

        <main>
            <div class="container-fluid">
                <div class="row justify-content-center">
                    <div class="col-12 col-sm-10 col-md-8 col-lg-7">
                        <div class="title">
                            <h1><?php echo $page->title() ?></h1>
                        </div>
                        <div class="intro">
                            <p><?php echo $page->text() ?></p>
                        </div>
                        <h2 class="heading-services-sub">Dienstleistungen</h2>
                        <div class="services-sub">
                            <ul>
                                <?php foreach($page->subservices()->toStructure() as $subservice): ?>
                                <li><?php echo $subservice->subservice() ?></li>
                                <?php endforeach ?>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <?php snippet('footer') ?>
        <script src="../assets/js/jquery.min.js"></script>
        <script src="../assets/js/bootstrap.bundle.min.js"></script>
        <script src="../assets/js/main.min.js"></script>
    </body>
</html>
