<!DOCTYPE html>
<html class="app <?= $page->template() ?> theme-default" lang="<?= $kirby->language()->code() ?>">

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= ($page->template() == 'home') ? ($site->site_meta_description()->isNotEmpty() ? "<meta name='description' content='" . $site->site_meta_description()->h() . "'>" : "") : ($page->page_meta_description()->isNotEmpty() ? "<meta name='description' content='" . $page->page_meta_description()->h() . "'>" : ""); ?>
    <?php if ($site->site_keywords()->isNotEmpty()) : ?>
    <meta name="keywords" content="<?= $site->site_keywords()->h() ?>">
    <?php endif ?>
    <?php if ($site->site_author()->isNotEmpty()) : ?>
    <meta name="author" content="<?= $site->site_author()->h() ?>">
    <?php endif ?>
    <meta name="language" content="<?= $kirby->language()->code() ?>">
    <meta name="robots" content="noodp">
    <title><?= $site->title()->h() ?></title>
    <link rel="icon" type="image/png" sizes="32x32" href="<?= url('/assets/favicons/favicon-32x32.png') ?>">
    <link rel="icon" type="image/png" sizes="16x16" href="<?= url('/assets/favicons/favicon-16x16.png') ?>">
    <link rel="icon shortcut" sizes="16x16 32x32" href="<?= url('/assets/favicons/favicon.ico') ?>">
    <link rel="stylesheet" href="<?= url('main.min.css') ?>">
    <script src='<?= url('vendor.head.min.js') ?>'></script>
    <?php if ($site->privacy_metrics()->isTrue()) : ?>
    <?php snippet('matomo') ?>
    <?php endif ?>
  </head>

  <body>
    <div class="app-main">
      <div class="document">
        <header class="document-header">
          <?php snippet('navigation/main/index') ?>
        </header>
        <section class="document-layout">
