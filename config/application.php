<?php

$envPath = dirname(__DIR__);

if (file_exists($envPath . '/.env')) {
    $dotenv = Dotenv\Dotenv::createMutable($envPath);
    $dotenv->load();
}

if ($_SERVER['HTTP_HOST'] !== 'www.schramm-reinigung.de' and $_SERVER['HTTP_HOST'] !== 'preview.schramm-reinigung.de') {
    $_SERVER['APP_ENV'] = 'development';
} elseif ($_SERVER['HTTP_HOST'] === 'preview.schramm-reinigung.de') {
    $_SERVER['APP_ENV'] = 'staging';
}

if ($_SERVER['APP_ENV'] !== 'production') {
    $env_config = __DIR__ . '/enviroments/' . $_SERVER['APP_ENV'] . '.php';

    if (file_exists($env_config)) {
        require_once $env_config;
    }
}
