<div class="snippet-component" data-is="list-services">
    <div class="container">
        <div class="list-services">
            <h3 class="title"><?php echo ucfirst($page->services()->key()) ?></h3>
            <div class="services">
                <ul class="list">
                    <?php foreach($page->services()->toStructure() as $service): ?>
                    <li class="list-item"><?php echo $service->service() ?></li>
                    <?php endforeach ?>
                </ul>
            </div>
        </div>
    </div>
</div>
