<div class="snippet" is="list-services">
  <div class="container">
    <div class="list-services">
      <div class="content context-content">
        <h3 class="title"><?= ucfirst($page->services()->key()) ?></h3>
        <div class="services">
          <ul class="list">
            <?php foreach ($page->services()->toStructure() as $service): ?>
            <li class="list-item"><?= $service->service() ?></li>
            <?php endforeach ?>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
