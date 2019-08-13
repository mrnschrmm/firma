<ul class="list">
    <?php foreach ($kirby->languages() as $language) : ?>
        <li class="list-item <?= e($kirby->language() == $language, 'list-item-isActive') ?>">
            <a class="list-link" href="<?= $page->url($language->code()) ?>" hreflang="<?= $language->code() ?>">
                <?= html($language->name()) ?>
            </a>
        </li>
    <?php endforeach ?>
</ul>
