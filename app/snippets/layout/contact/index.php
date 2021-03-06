<div class="snippet layout-contact">
    <section class="contact-layout">
        <header class="contact-header">
            <?php snippet('component/block-page-header/index') ?>
        </header>
        <main class="contact-main">
            <?php snippet('component/block-wysiwyg/index', ['text' => $page->page_description()]) ?>
            <?php snippet('component/block-contact/index') ?>
            <?php snippet('component/block-map/index') ?>
        </main>
    </section>
</div>
