<?php snippet('header') ?>

    <main>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="title">
                        <h1><?php echo $page->title() ?></h1>
                    </div>
                    <?php snippet('submenu') ?>
                    <div class="intro">
                        <p><?php echo $page->text() ?></p>
                    </div>
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
