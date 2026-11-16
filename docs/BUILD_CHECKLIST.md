# CatSpace MVP checklist

## Implemented in launch/mvp-finder-catalog
- [x] Keep all nine original ASINs in D1 as pending candidates.
- [x] Finder gains floor-space and preferred-location controls.
- [x] Finder excludes zero-relevance matches rather than listing every product.
- [x] Finder explains that filters are editorial signals, not verified physical compatibility.
- [x] Category pages explain buying criteria and load only active, verified products from the public API.
- [x] Affiliate disclosure included on category pages.
- [x] README updated to reflect the existing Cloudflare Pages deployment.

## Must be checked in the owner's Cloudflare account
- [ ] Confirm D1 binding named DB.
- [ ] Confirm ADMIN_TOKEN is configured as a Functions secret.
- [ ] Apply Cloudflare Access to /admin/*.
- [ ] Run production smoke tests for /api/products and /api/admin/products.
- [ ] Confirm the custom domain and DNS when purchased.
- [ ] Confirm Amazon Associates US Tracking ID and policy-compliant links.

## Editorial verification still required
- [ ] Verify all nine ASINs, variants and manufacturer sources.
- [ ] Record product dimensions, platform dimensions, stated weight limits and installation details only from reliable sources.
- [ ] Publish only products marked verified and active.
- [ ] Add actual verified product comparison data before claiming category recommendations.
