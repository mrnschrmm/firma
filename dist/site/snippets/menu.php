<nav class="nav-main" role="navigation">
    <button id="btn-menu" class="btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="20" viewBox="0 0 12 20">
            <g id="ico-menu" class="ico">
                <path id="ico-object-bottom" d="M0 18h12v2H0z"/>
                <path id="ico-object-center" d="M0 9h12v2H0z"/>
                <path id="ico-object-top" d="M0 0h12v2H0z"/>
            </g>
        </svg>
    </button>
    <ul class="menu">
        <?php foreach($pages->visible()->without("home") as $item): ?>
        <li class="menu-item">
            <a <?php e($item->isOpen(), ' class="active"') ?> href="<?= $item->url() ?>"><?= $item->title()->html() ?></a>
        </li>
        <?php endforeach ?>
    </ul>
</nav>
