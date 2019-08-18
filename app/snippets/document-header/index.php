<!DOCTYPE html>
<html class="html <?= $page->template() ?> theme-default" lang="<?= $kirby->language()->code() ?>">

<head>
  <meta charset="utf-8">
  <title><?= $site->title() ?></title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="description" content="<?= $site->description() ?>">
  <meta name="language" content="<?= $kirby->language()->code() ?>">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="author" content="<?= $site->author() ?>">
  <meta name="robots" content="noodp">
  <link rel="stylesheet" href="<?= url('main.min.css') ?>">
  <link rel="shortcut icon" sizes="16x16 32x32" href="<?= url('/assets/favicons/favicon.ico') ?>">
  <link rel="icon" type="image/png" sizes="16x16" href="<?= url('/assets/favicons/favicon-16x16.png') ?>">
  <link rel="icon" type="image/png" sizes="32x32" href="<?= url('/assets/favicons/favicon-32x32.png') ?>">
  <link rel="canonical" href="<?= $page->url($kirby->language()->code()) ?>">
  <script src='<?= url('vendor.head.min.js') ?>'></script>
</head>

<body>
