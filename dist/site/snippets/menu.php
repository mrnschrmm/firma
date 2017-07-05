<nav class="nav-main" role="navigation">
    <ul class="menu">
        <?php foreach($pages->visible() as $item): ?>
        <li class="menu-item">
            <a <?php e($item->isOpen(), ' class="active"') ?> href="<?= $item->url() ?>"><?= $item->title()->html() ?></a>
        </li>
        <?php endforeach ?>
    </ul>
</nav>
