<div class="snippet" is="block-contact">
  <div class="container">
    <div class="columns context-content">
      <div class="column">
        <div class="address">
          <span class="address-company"><?= $page->company() ?></span>
          <span class="address-extra"><?= $page->extra() ?></span>
          <span class="address-street"><?= $page->street() ?></span>
          <span class="address-zip"><?= $page->zip() ?>&nbsp;<?= $page->location() ?></span>
        </div>
      </div>
      <div class="column">
        <div class="channel">
          <span class="channel-phone">Tel:&nbsp;<?= $page->phone() ?></span>
          <span class="channel-fax">Fax:&nbsp;<?= $page->fax() ?></span>
          <span class="channel-mail"><a href="mailto:<?= $page->email() ?>"><?= $page->email() ?></a></span>
        </div>
      </div>
    </div>
  </div>
</div>
