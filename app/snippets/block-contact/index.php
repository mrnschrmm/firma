<div class="snippet-component" is="block-contact">
  <div class="container">
    <div class="columns">
      <div class="column column-isHalf">
        <div class="contact">
          <div class="contact-channel">
            <p>Tel:&nbsp;<?= $page->phone() ?></p>
            <p>Fax:&nbsp;<?= $page->fax() ?></p>
            <p><a href="mailto:<?= $page->email() ?>"><?= $page->email() ?></a></p>
          </div>
        </div>
      </div>
      <div class="column column-isHalf">
        <div class="contact">
          <div class="contact-address">
            <p><?= $page->company() ?></p>
            <p><?= $page->street() ?></p>
            <p><?= $page->zip() ?>&nbsp;<?= $page->location() ?></p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
