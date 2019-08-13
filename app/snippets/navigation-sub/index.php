<?php

if ($root = $pages->findOpen()) {
    $items = $root->children()->visible();
}

if ($items and $items->count()) : ?>
<div class="snippet-component" data-is="navigation-sub">
    <div class="container">
        <div class="navigation-sub">
            <nav class="menu">
                <ul class="list">
                    <?php foreach ($items as $item) : ?>
                        <li class="list-item"><a<?php e($item->isOpen(), ' class="active"') ?> href="<?php echo $item->url() ?>"><?php echo $item->title()->html() ?></a></li>
                    <?php endforeach ?>
                </ul>
            </nav>
        </div>
    </div>
</div>
<?php endif ?>
