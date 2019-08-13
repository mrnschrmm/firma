<ul class="list">
    <?php foreach ($pages->visible()->without('home') as $item) : ?>
        <li class="list-item <?= r($item->isOpen(), ' is-active') ?>">
            <a class="list-link" href="<?= $item->url() ?>"><?= $item->title()->html() ?></a>
        </li>
    <?php endforeach ?>
</ul>
