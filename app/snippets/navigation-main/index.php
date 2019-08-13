<div class="snippet-component" data-is="navigation-main">
    <div class="navigation-main">
        <a class="brand" href="<?= $site->url() ?>"><?= $site->title() ?></a>
        <button class="toggle" type="button">
            <span class="toggle-icon"></span>
        </button>
        <nav class="menu">
            <div class="menu-main">
                <?php snippet('navigation-main/partials/main/index', ['pages' => $pages]) ?>
            </div>
            <div class="menu-lang">
                <?php snippet('navigation-main/partials/lang/index', ['kirby' => $kirby, 'page' => $page]) ?>
            </div>
        </nav>
    </div>
</div>
