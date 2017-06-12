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
<body>
    <header>
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h1 class="logo">
                        <a href="<?php echo $site->url() ?>"><?php echo $site->title() ?></a>
                    </h1>
                </div>
                <div class="col-12">
                    <?php snippet('menu') ?>
                </div>
            </div>
        </div>
    </header>
