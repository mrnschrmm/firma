<?php
include '../kirby/bootstrap.php';

$kirby = new Kirby([
    'urls' => [
        'index' => 'http://preview.schramm-reinigung.de',
        'media' => 'http://preview.schramm-reinigung.de/media',
    ],
    'roots' => [
        'index'    => __DIR__,
        'base'     => $base    = dirname(__DIR__),
        'content'  => $base . '/content',
        'site'     => $base . '/site',
        'kirby'    => $base . '/kirby',
        'storage'  => $storage = $base . '/storage',
        'accounts' => $storage . '/accounts',
        'cache'    => $storage . '/cache',
        'sessions' => $storage . '/sessions',
    ]
]);

echo $kirby->render();
