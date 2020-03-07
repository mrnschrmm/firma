<?= '<?xml version="1.0" encoding="utf-8"?>'; ?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <?php foreach ($pages as $p): ?>
    <?php if (in_array($p->uri(), $ignore)) continue ?>
    <url>
        <loc><?= html($p->url('')) ?></loc>
        <lastmod><?= $p->modified('c', 'date') ?></lastmod>
        <priority><?= ($p->isHomePage()) ? 1 : number_format(0.5 / $p->depth(), 1) ?></priority>
        <xhtml:link
            rel="alternate"
            hreflang="x-default"
            href="<?= html($p->url('')) ?>" />
        <?php foreach ($languages as $l): ?>
        <xhtml:link
            rel="alternate"
            hreflang="<?= $l->code() ?>"
            href="<?= $p->url($l->code()) ?>" />
        <?php endforeach ?>
    </url>
    <?php foreach ($languages as $lang): ?>
    <url>
        <loc><?= html($p->url($lang->code())) ?></loc>
        <lastmod><?= $p->modified('c', 'date') ?></lastmod>
        <priority><?= ($p->isHomePage()) ? 1 : number_format(0.5 / $p->depth(), 1) ?></priority>
        <xhtml:link
            rel="alternate"
            hreflang="x-default"
            href="<?= html($p->url('')) ?>" />
        <?php foreach ($languages as $l): ?>
        <xhtml:link
            rel="alternate"
            hreflang="<?= $l->code() ?>"
            href="<?= $p->url($l->code()) ?>" />
        <?php endforeach ?>
    </url>
    <?php endforeach ?>
    <?php endforeach ?>
</urlset>
