<!DOCTYPE html>
<html lang="<?= $kirby->language()->code() ?>" class="app <?= $page->template() ?> theme-default">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">

        <title><?= ($page->template() == 'home') ? $site->title()->h() : $page->title()->h() . ' | ' . $site->title()->h() ?></title>

        <link rel="stylesheet" href="<?= url('main.min.css') ?>">
        <link rel="script" href="<?= url('vendor.head.min.js') ?>">
        <link rel="icon" type="image/png" sizes="32x32" href="<?= url('/assets/favicons/favicon-32x32.png') ?>">
        <link rel="icon" type="image/png" sizes="16x16" href="<?= url('/assets/favicons/favicon-16x16.png') ?>">
        <link rel="icon shortcut" sizes="16x16 32x32" href="<?= url('/assets/favicons/favicon.ico') ?>">

        <meta name="description" content="<?= ($page->template() == 'home') ? $site->site_meta_description()->h() : $page->page_meta_description()->h() ?>" />
        <meta name="author" content="<?= $site->site_author()->h() ?>">
        <meta name="keywords" content="<?= $site->site_keywords()->h() ?>">

        <meta property="og:type" content="website" />
        <meta property="og:title" content="<?= ($page->template() == 'home') ? $site->title()->h() : $page->title()->h() . ' | ' . $site->title()->h() ?>" />
        <meta property="og:url" content="<?= html($site->url()) ?>" />
        <meta property="og:locale" content="<?= $kirby->language()->code() ?>_DE">
        <meta property="og:description" content="<?= ($page->template() == 'home') ? $site->site_meta_description()->h() : $page->page_meta_description()->h() ?>">

        <meta itemprop="name" content="<?= ($page->template() == 'home') ? $site->title()->h() : $page->title()->h() . ' | ' . $site->title()->h() ?>">
        <meta itemprop="description" content="<?= ($page->template() == 'home') ? $site->site_meta_description()->h() : $page->page_meta_description()->h() ?>">

        <?php if ($site->privacy_metrics()->isTrue() and $_SERVER['MATOMO'] === 'true') : ?>
        <?php snippet('metrics') ?>
        <?php endif ?>

    </head>

    <body>
        <div class="app-main">
            <div class="document">
                <header class="document-header">
                    <?php snippet('navigation/main/index') ?>
                </header>
                <section class="document-layout">
