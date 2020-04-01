<navigation-main class="snippet">
    <div class="navigation-main">
        <a class="brand" href="<?= $site->url() ?>"><?= $site->title() ?></a>
        <button class="toggle" data-toggle-menu type="button"><?= svg('assets/icons/ico-ui-menu-24x18.svg') ?></button>
        <nav class="menu">
            <div class="menu-main">
                <?php snippet('navigation/main/partials/main/index', ['pages' => $pages]) ?>
            </div>
            <div class="menu-lang">
                <?php snippet('navigation/main/partials/lang/index', ['kirby' => $kirby, 'page' => $page]) ?>
            </div>
        </nav>
    </div>
</navigation-main>
