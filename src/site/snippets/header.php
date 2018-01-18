<header role="banner">
    <div class="container-fluid">
        <nav class="navbar navbar-expand-md navbar-dark" role="navigation">
            <a class="navbar-brand logo-color text-uppercase" href="<?php echo $site->url() ?>"><?php echo $site->title() ?></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ml-auto justify-content-center">
                    <?php foreach($pages->visible()->without('home') as $item): ?>
                    <li class="menu-item <?= r($item->isOpen(), ' is-active') ?>">
                        <a class="nav-link" href="<?= $item->url() ?>"><?= $item->title()->html() ?></a>
                    </li>
                    <?php endforeach ?>
                </ul>
            </div>
        </nav>
    </div>
</header>
<div class="company-contact">
    <p>
        <a href="tel:+493658310254" class="tel">Gera — +49 365 831 02 54</a>
        <a href="mailto:info@schramm-reinigung.de">info@schramm-reinigung.de</a>
    </p>
</div>