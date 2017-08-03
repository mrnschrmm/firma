<?php

$items = false;

// get the open item on the first level
if($root = $pages->findOpen()) {

    // get visible children for the root item
    $items = $root->children()->visible();
}

// only show the menu if items are available
if($items and $items->count()): ?>
    <div class="row">
        <nav class="nav-sub">
            <ul class="menu-sub">
                <?php foreach($items as $item): ?>
                    <li class="col-12 col-sm-6 col-md-4"><a<?php e($item->isOpen(), ' class="active"') ?> href="<?php echo $item->url() ?>"><?php echo $item->title()->html() ?></a></li>
                <?php endforeach ?>
            </ul>
        </nav>
    </div>
<?php endif ?>
