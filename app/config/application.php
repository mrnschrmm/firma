<?php

$path = dirname(__DIR__, 2) . "\public";

if (file_exists($root . '/.env')) {
    $dotenv = Dotenv\Dotenv::createMutable($path);
    $env = $dotenv->load();
}

if ($_SERVER['HTTP_HOST'] !== 'schramm-reinigung.de' or $_SERVER['HTTP_HOST'] !== 'preview.schramm-reinigung.de') {
    $env['APP_ENV'] = 'development';
}

if ($env['APP_ENV'] !== 'production') {
    $env_config = __DIR__ . '\\' . $env['APP_ENV'] . '.php';

    if (file_exists($env_config)) {
        require_once $env_config;
    }
}

// var_dump($_SERVER);
