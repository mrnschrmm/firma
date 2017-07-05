<?php snippet('header') ?>

    <main>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-9">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <?php snippet('submenu') ?>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                </div>
            </div>
        </div>
    </main>

<?php snippet('footer') ?>
