# CatSpace Guide — Starter técnico

Este paquete es el punto de partida técnico del portal CatSpace Guide.

## Incluye
- Sitio público responsive en HTML/CSS/JavaScript.
- Tres páginas de categoría.
- API de lectura de productos con Cloudflare Pages Functions + D1.
- Esquema SQL inicial para catálogo, categorías, fuentes, artículos, reemplazos e historial.
- Página administrativa inicial protegida en el servidor mediante una clave de administrador (prototipo; ver seguridad).

## Importante
Este paquete **no está desplegado** y no contiene credenciales de Amazon, tracking ID ni precios.
Los nueve productos iniciales se registran como candidatos pendientes de verificación. No deben publicarse como recomendaciones definitivas hasta revisar ASIN, variante, especificaciones, disponibilidad y fuentes.

## Despliegue inicial recomendado
1. Crear un repositorio Git para CatSpace Guide.
2. Subir el contenido de esta carpeta.
3. En Cloudflare Pages, conectar el repositorio.
4. Crear una base D1 y ejecutar `schema.sql`.
5. En Pages > Settings > Bindings, añadir D1 con el nombre `DB`.
6. Configurar `ADMIN_TOKEN` como secret de Functions.
7. Publicar y probar las rutas.

## Rutas
- `/` — inicio
- `/large-cat-trees/`
- `/cat-wall-furniture/`
- `/window-perches/`
- `/admin/` — panel inicial
- `/api/products` — catálogo público
- `/api/admin/products` — listado administrativo (requiere token)

## D1
Ejecutar:
```bash
wrangler d1 create catspace-guide-db
wrangler d1 execute catspace-guide-db --file=./schema.sql
```
Después configurar el binding `DB` en Cloudflare Pages.

## Seguridad
El panel de esta primera versión es una base técnica. Antes de usarlo en producción:
- Activar Cloudflare Access o un sistema de autenticación robusto.
- No compartir `ADMIN_TOKEN`.
- No introducir credenciales de Amazon en JavaScript del navegador.
- Revisar las políticas vigentes de Amazon Associates y Creators API.

## Datos
Los productos tienen un estado `review` y `verification_status='pending'`. No se muestran como seleccionados ni se publican precios.
