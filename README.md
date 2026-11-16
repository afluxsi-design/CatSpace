# CatSpace Guide — estado del MVP

CatSpace está publicado en Cloudflare Pages en https://catspace-6mk.pages.dev/ y el repositorio de origen es https://github.com/afluxsi-design/CatSpace.

## Arquitectura actual
- Sitio estático HTML/CSS/JavaScript.
- Cloudflare Pages Functions en `functions/api`.
- Cloudflare D1 mediante el binding `DB`.
- `/api/products` expone únicamente productos activos y verificados.
- `/api/admin/products` requiere el secret `ADMIN_TOKEN`.
- `/admin/` es una herramienta interna; proteger la ruta con Cloudflare Access además de la autorización de API.

## Catálogo
Los nueve ASIN del archivo `schema.sql` son candidatos, no recomendaciones aprobadas. Deben verificarse ASIN, variante, marca, dimensiones, peso admitido, método de instalación, contenido del paquete y enlaces. No inventar precios ni especificaciones.

## Finder
El Finder usa el catálogo publicado y filtros editoriales de categoría, tamaño de gato, espacio disponible y ubicación preferida. Los filtros de espacio y ubicación son señales de relevancia por categoría, no garantías de compatibilidad física. Solo la documentación del producto puede confirmar medidas, capacidad y montaje.

## Configuración que requiere acceso del propietario
1. Confirmar el binding D1 `DB` en Pages.
2. Configurar `ADMIN_TOKEN` como secret de Functions; nunca en el repositorio.
3. Proteger `/admin/*` mediante Cloudflare Access.
4. Verificar los endpoints de producción.
5. Configurar el dominio propio cuando esté comprado.
6. Confirmar el Tracking ID de Amazon Associates US e incorporarlo solo donde corresponda.

## Lanzamiento
No publicar un candidato como verificado sin fuente comprobable. No mostrar precios estáticos como precios actuales. Revisar disclosure y políticas vigentes de Amazon antes de activar enlaces monetizados.
