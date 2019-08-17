<?php
include __DIR__ . '/dist/kirby/bootstrap.php';

$root = __DIR__;

$kirby = new Kirby([
    'urls' => [
        'index' => 'http://firma.local.blee.ch',
        'media' => 'http://firma.local.blee.ch/access/media',
    ],
    'roots' => [
        'site' => $root . '/dist/site',
        'kirby' => $root . '/dist/kirby',
        'cache' => $root . '/access/cache',
        'config' => $root . '/dist/config',
        'accounts' => $root . '/access/accounts',
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
