<?php snippet('header') ?>

    <main>
        <div class="container-fluid contact">
            <div class="row justify-content-center">
                <div class="col-5">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <?php snippet('submenu') ?>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
                    <div class="content">
                        <div class="row">
                            <div class="col-6">
                                <p>Tel:&nbsp;<?php echo $page->phone() ?></p>
                                <p>Fax:&nbsp;<?php echo $page->fax() ?></p>
                                <p><?php echo $page->email() ?></p>
                            </div>
                            <div class="col-6">
                                <p><?php echo $page->company() ?></p>
                                <p><?php echo $page->street() ?></p>
                                <p><?php echo $page->zip() ?>&nbsp;<?php echo $page->location() ?></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

<?php snippet('footer') ?>
