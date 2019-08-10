<div class="snippet-component" data-is="navigation-main">
    <div class="navigation-main">
        <a class="brand" href="<?php echo $site->url() ?>"><?php echo $site->title() ?></a>
        <button class="toggle" type="button">
            <span class="toggle-icon"></span>
        </button>
        <nav class="menu">
            <div class="menu-main">
                <ul class="list">
                    <?php foreach($pages->visible()->without('home') as $item): ?>
                        <li class="list-item <?= r($item->isOpen(), ' is-active') ?>">
                            <a class="list-link" href="<?= $item->url() ?>"><?= $item->title()->html() ?></a>
                        </li>
                    <?php endforeach ?>
                </ul>
            </div>
            <div class="menu-lang">
                <ul class="list">
                    <?php foreach($kirby->languages() as $language): ?>
                        <li class="list-item <?php e($kirby->language() == $language, 'list-item-isActive') ?>">
                            <a class="list-link" href="<?= $page->url($language->code()) ?>" hreflang="<?php echo $language->code() ?>">
                                <?= html($language->name()) ?>
                            </a>
                        </li>
                    <?php endforeach ?>
                </ul>
            </div>
        </nav>
    </div>
</div>
