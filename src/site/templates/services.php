<?php snippet('header') ?>

    <main>
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="title">
                        <p><?php echo $page->title() ?></p>
                    </div>
                    <div class="submenu">
                        <?php snippet('submenu') ?>
                    </div>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                </div>
            </div>
        </div>
    </main>

<?php snippet('footer') ?>
