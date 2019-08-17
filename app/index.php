<?php
include 'vendor/autoload.php';

$root = __DIR__;

$kirby = new Kirby([
    'urls' => [
        'index' => 'http://firma.local.blee.ch',
        'media' => 'http://firma.local.blee.ch/access/media',
    ],
    'roots' => [
        'site' => $root . '/dist/site',
        'cache' => $root . '/access/cache',
        'accounts' => $root . '/access/accounts',
        'configs' => $root . '/dist/configs',
        'sessions' => $root . '/access/sessions',
        'blueprints' => $root . '/dist/blueprints',
        'controllers' => $root . '/dist/controllers',
        'collections' => $root . '/dist/collections',
        'languages' => $root . '/dist/languages',
        'templates' => $root . '/dist/templates',
        'snippets' => $root . '/dist/snippets',
        'plugins' => $root . '/dist/plugins',
        'content' => $root . '/access/content',
        'media' => $root . '/access/media',
    ]
]);

echo $kirby->render();
