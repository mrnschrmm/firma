<div class="snippet-component" data-is="block-contact">
    <div class="content">
        <div class="column">
            <div class="column column-isHalf">
                <div class="contact">
                    <div class="contact-channel">
                        <p>Tel:&nbsp;<?php echo $page->phone() ?></p>
                        <p>Fax:&nbsp;<?php echo $page->fax() ?></p>
                        <p><a href="mailto:<?php echo $page->email() ?>"><?php echo $page->email() ?></a></p>
                    </div>
                </div>
            </div>
            <div class="column column-isHalf">
                <div class="contact">
                    <div class="contact-address">
                        <p><?php echo $page->company() ?></p>
                        <p><?php echo $page->street() ?></p>
                        <p><?php echo $page->zip() ?>&nbsp;<?php echo $page->location() ?></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
