<div class="snippet" is="layout-page">
  <section class="page-layout">
    <header class="page-header">
      <?php snippet('component/block-page-header/index') ?>
    </header>
    <main class="page-main">
      <?php snippet('component/block-wysiwyg/index', ['text' => $page->page_description()]) ?>
    </main>
    <footer class="page-footer">
      <?php snippet('component/block-page-footer/index') ?>
    </footer>
  </section>
</div>
