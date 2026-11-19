-- CatSpace catalog candidate expansion — 2026-11-19
-- All additions remain status='review' and verification_status='pending'.
-- Do not publish until exact Amazon US listings and specifications are verified.

UPDATE products
SET name='FUKUMARU 4-in-1 Cat Wall Shelves, Gray',
    brand='FUKUMARU',
    category_id='CAT-WALL',
    asin='B0D2GZ4S1Q',
    marketplace='US',
    amazon_url='https://www.amazon.com/dp/B0D2GZ4S1Q',
    short_description='Candidate wall climbing system; verify listing, components and load rating.',
    status='review',
    verification_status='pending',
    updated_at=CURRENT_TIMESTAMP
WHERE product_id='WALL-001';

UPDATE products
SET name='Cat Wall Shelves 5-in-1 Brown',
    brand='Unconfirmed brand',
    category_id='CAT-WALL',
    asin='B09WDDGP2V',
    marketplace='US',
    amazon_url='https://www.amazon.com/dp/B09WDDGP2V',
    short_description='ASIN was misclassified as a window perch; inspection indicates wall shelves.',
    status='review',
    verification_status='pending',
    updated_at=CURRENT_TIMESTAMP
WHERE product_id='WINDOW-003';

INSERT OR IGNORE INTO products
(product_id,name,brand,category_id,asin,marketplace,amazon_url,status,verification_status,short_description)
VALUES
('TREE-004','Heybly 71-inch Cat Tree, Light Gray','Heybly','CAT-TREE','B0GSFG68GB','US','https://www.amazon.com/dp/B0GSFG68GB','review','pending','Inspection showed a Heybly cat tree, not wall furniture. Confirm variant and weight limit.'),
('TREE-005','Feandrea 67.7-inch Multi-Level Cat Tree UPCT18WS','Feandrea','CAT-TREE','B078H9DCTX','US','https://www.amazon.com/dp/B078H9DCTX','review','pending','Candidate from secondary research; confirm listing, dimensions and platform capacity.'),
('TREE-006','PAWZ Road 72-inch Large Cat Tree AM01','PAWZ Road','CAT-TREE','B0CP7PKH81','US','https://www.amazon.com/dp/B0CP7PKH81','review','pending','Candidate from secondary research; verify variant, dimensions and load rating.'),
('WALL-004','Cat Wall Shelves 5-in-1 Brown','Unconfirmed brand','CAT-WALL','B09WDDGP2V','US','https://www.amazon.com/dp/B09WDDGP2V','review','pending','ASIN was misclassified as a window perch; verify brand, wall mounting and load rating.'),
('WALL-005','XiaZ Corner Cat Shelf with 3 Wide Perch Steps','XiaZ','CAT-WALL','B0FJFJR4GV','US','https://www.amazon.com/dp/B0FJFJR4GV','review','pending','Candidate; reported 25 lb capacity, verify listing and intended use.'),
('WALL-006','FUKUMARU 2-Platform Wall Shelves, Solid Rubberwood','FUKUMARU','CAT-WALL','B0DRVMY62Y','US','https://www.amazon.com/dp/B0DRVMY62Y','review','pending','Candidate from secondary research; verify dimensions, load rating and included pieces.'),
('WALL-007','FUKUMARU Four-Step Cat Wall Shelf','FUKUMARU','CAT-WALL','B087LR5LWP','US','https://www.amazon.com/dp/B087LR5LWP','review','pending','Candidate from secondary research; verify variant and mounting details.'),
('WINDOW-003','Sunhoo Cat Hammock Window Sill Perch, Large','Sunhoo','CAT-WINDOW','B0DK4R7C9F','US','https://www.amazon.com/dp/B0DK4R7C9F','review','pending','Candidate; reported 40 lb capacity, confirm listing and installation.'),
('WINDOW-004','K&H Deluxe Bolster Cat Window Perch','K&H Pet Products','CAT-WINDOW','B07HMVB68D','US','https://www.amazon.com/dp/B07HMVB68D','review','pending','Candidate; reported 40 lb capacity, confirm exact listing and variant.'),
('WINDOW-005','PETSFIT Dual-Level Cat Window Perch','PETS FIT','CAT-WINDOW','B0FQNR3RMX','US','https://www.amazon.com/dp/B0FQNR3RMX','review','pending','Candidate; reported 45 lb capacity, confirm listing and installation requirements.');

-- Reclassify an ASIN that inspection showed to be wall furniture, not a window perch.
