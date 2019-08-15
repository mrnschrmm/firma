<ul class="list list--sub">
  <?php foreach ($items as $item) : ?>
  <li class="list-item">
    <a class="list-link" href="<?php echo $item->url() ?>"><?php echo $item->title()->html() ?></a>
  </li>
  <?php endforeach ?>
</ul>
