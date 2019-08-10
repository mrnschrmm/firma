<?php
include 'vendor/autoload.php';

$root = __DIR__;

$kirby = new Kirby([
    'urls' => [
        'index' => 'http://firma.local.blee.ch',
        'media' => 'http://firma.local.blee.ch/access/media',
    ],
    'roots' => [
        'cache' => $root . '/access/cache',
        'site' => $root . '/dist/site',
        'accounts' => $root . '/access/accounts',
        'sessions' => $root . '/access/sessions',
        'controllers' => $root . '/dist/controllers',
        'collections' => $root . '/dist/collections',
        'blueprints' => $root . '/dist/blueprints',
        'templates' => $root . '/dist/templates',
        'snippets' => $root . '/dist/snippets',
        'plugins' => $root . '/dist/plugins',
        'content' => $root . '/access/content',
        'media' => $root . '/access/media',
    ]
]);

echo $kirby->render();
