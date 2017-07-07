<!DOCTYPE html>
<html lang="en">
<head>
    <title><?php echo $site->title() ?></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="<?php echo $site->description() ?>">
    <meta name="keywords" content="<?php echo $site->keywords() ?>">
    <meta name="msapplication-TileColor" content="#062299">
    <link rel="shortcut icon" sizes="16x16 24x24 32x32 48x48 64x64" href="/favicon.ico">
    <!--build:css assets/css/main.min.css-->
    <link rel="stylesheet" type="text/css" href="/assets/css/main.min.css">
    <!--endbuild-->
</head>
<body id="contact">
    <?php snippet('header') ?>

    <main>
        <div class="container-fluid contact">
            <div class="row justify-content-center">
                <div class="col-6">
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
                                <p><a href="mailto:<?php echo $page->email() ?>"><?php echo $page->email() ?></a></p>
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
</body>
</html>
