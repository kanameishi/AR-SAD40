# Handoff - chapa corrugada nominal 76 x 25 mm

**Fecha de corte:** 2026-08-13
**Estado:** evidencia cerrada; seleccion entre las filas 2,8 y 3,5 mm pendiente del agente responsable
**Checkpoint unico:** `dev/chapa/HANDOFF-chapa-76x25-espesor-2026-08-13.md`

## Objective

- Dar al agente de `AR-SAD40` una base auditable para decidir si adopta la fila exacta de espesor especificado 2,8 mm o 3,5 mm para un perfil CSP denominado 76 x 25 mm.
- Repositorio/worktree canonico: `/Users/averrik/Cloud/github/projects/AR-SAD40`; rama `main`; base observada al preparar este handoff: `465a8e748afb9d69763e00c92f7473914dead71c`.
- Agente receptor vivo: tarea Codex `019fe2e1-db10-7830-bbe3-753a2df78b86`, titulo `liner San Francisco`, host `local`.
- Propiedad del worktree: todas las modificaciones y archivos sin seguimiento preexistentes pertenecen al usuario y al agente receptor. Este handoff agrega solamente este archivo nuevo; no modifica calculo, configuracion, tablas de referencia ni reporte.
- Alcance: geometria y propiedades seccionales por unidad de ancho proyectado, semantica del espesor y trazabilidad de fuentes.
- Exclusiones: seleccion del producto real, verificacion resistente, corrosión, juntas, pernos y cualquier interpolacion a 3,0 mm.
- Criterio de cierre: elegir una de las dos filas solamente despues de identificar la familia de producto y la categoria del dato `t0 = 3,0 mm`; registrar por separado espesor especificado/nominal y espesor base de diseño.

## Rulings

1. Los 25 mm son la **profundidad vertical nominal entre pico y valle**. No son espesor, radio ni semionda.
2. El paso, la profundidad y el espesor son datos independientes. El dato dudoso es la categoria del `3,0 mm`, no la profundidad de 25 mm.
3. No se interpola a 3,0 mm y no se reutiliza la tabla imperial NCSPA `3 x 1 in` del modelo anterior.
4. La fila 2,8 o 3,5 de CSPI se adopta solo si el producto se clasifica como chapa para **corrugated steel pipe (CSP)** con el perfil nominal que esa fuente declara. La coincidencia del nombre `76 x 25` no prueba que sea el perfil exacto de otro fabricante.
5. En la familia CSP de CSA G401, 2,80 y 3,50 mm son espesores **nominales de pedido que incluyen el acero base y el recubrimiento metalico**. Los espesores base de diseño asociados son 2,64 y 3,35 mm. Un recubrimiento polimerico adicional no queda cuantificado por esas filas.
6. En la tabla CSPI, las propiedades se calculan con el espesor de diseño, aunque la fila se identifica primero por espesor especificado. Por lo tanto, no se debe escribir 2,8 o 3,5 en un campo que siga llamandose y significando `baseThicknessMm` sin cambiar el contrato de datos.
7. `t0 = 3,0 mm` permanece `UNKNOWN`: puede ser espesor nominal de pedido, espesor medido de acero base, espesor base de diseño, espesor total con recubrimiento o un valor redondeado. Ninguna fuente examinada permite decidirlo.

## Verdicts

### A. Fuente que contiene las dos filas candidatas

**Editor:** Corrugated Steel Pipe Institute (CSPI).
**Producto/clase:** corrugated CSP sheet, perfil denominado `76 x 25 mm`, anular o helicoidal.
**Fuente:** [Handbook of Steel Drainage & Highway Construction Products - Chapter 2](https://cspi.ca/wp-content/uploads/2021/04/handbook_chapter02.pdf)
**Localizador exacto:** PDF fisico 7/78; pagina impresa 23; **Table 2.4**, encabezado `Section design properties for corrugated CSP sheet - Corrugation profile: 76 x 25 mm (annular or helical)`; filas encabezadas `2.8` y `3.5`.
**SHA-256 del PDF consultado:** `bae80d7c9bc80482a19fba68a2578e332cda9db8783e8e997495ed50a35c81ae`.

| Magnitud publicada | Fila 2,8 | Fila 3,5 | Unidad/encabezado |
|---|---:|---:|---|
| espesor especificado | 2,8 | 3,5 | `Wall Thickness - Specified T`, mm |
| espesor de diseño | 2,64 | 3,35 | `Wall Thickness - Design T`, mm |
| area por ancho proyectado | 3,281 | 4,169 | `Area A`, mm2/mm |
| longitud tangente | 22,504 | 21,688 | `Tangent Length TL`, mm |
| angulo tangente | 45,479 | 46,035 | `Tangent Angle theta`, grados |
| momento de inercia por ancho proyectado | 249,73 | 319,77 | `Moment of Inertia I`, mm4/mm |
| modulo resistente elastico | 17,81 | 22,24 | `Section Modulus S`, mm3/mm |
| radio de giro | 8,724 | 8,758 | `Radius of Gyration r`, mm |
| factor de ancho desarrollado | 1,243 | 1,244 | `Developed Width Factor WF`, adimensional |

La figura incluida en la misma pagina declara para este perfil: paso real 76,2 mm, profundidad real 25,4 mm y radio 14,29 mm. El texto de la pagina impresa 18 describe estos perfiles como arcos circulares conectados por tangentes. Con `TL` y `theta` de cada fila, la fuente publica la geometria necesaria de su perfil. Esta geometria es la conversion declarada por CSPI; no es exactamente la geometria BCT de 76,0/25,0/R14.

### B. Norma que aclara geometria y categorias de espesor

**Norma:** CSA G401-14, *Corrugated steel pipe products*.
**Fuente:** [PDF CSA G401-14 alojado por CSPI](https://cspi.ca/sites/default/files/download/CSA%20G401-14.pdf)
**SHA-256 del PDF consultado:** `b173f628c03f3258dcf21ce10e64abe070a38e3d7aad31cfc6393b96a4787903`.

- **Table 6**, PDF fisico 56/105, pagina impresa 52, fila encabezada por paso nominal `76` y profundidad nominal `25`: confirma paso real 76,2 mm y profundidad real 25,4 mm.
- **Table 3**, PDF fisico 53/105, pagina impresa 49, filas `2.80` y `3.50`: tolerancias respectivas `+/- 0,20` y `+/- 0,23` mm. La nota de tabla declara que el espesor nominal de CSP incluye acero base y recubrimiento metalico.
- **Clause 3 - Nominal thickness**, PDF fisico 18/105, pagina impresa 14: distingue CSP sheet, cuyo nominal incluye recubrimiento metalico, de structural plate, cuyo nominal es acero base y excluye ese recubrimiento.
- **Table A.1**, PDF fisico 98/105, pagina impresa 94, filas `2.80` y `3.50`: espesores base de diseño 2,64 y 3,35 mm.
- La **Table A.2** de esa misma pagina contiene `3.00 -> 2.84`, pero pertenece a *structural plate and deep corrugated steel pipe*. No se puede combinar con la Table 2.4 de CSP sheet.

El PDF lleva una licencia nominal de usuario unico y prohibicion de redistribucion. Por eso este handoff conserva el enlace directo y el hash, pero no copia el archivo al repositorio.

### C. Fuente de fabricante para un perfil metricamente distinto

**Fabricante:** Bergschenhoek Civiele Techniek (BCT).
**Producto:** SPIROsol y SPIROsol type SPM.
**Normas declaradas para el acero:** NEN-EN 10346:2009 y NEN-EN 10143:2006.
**Fuente:** [SPIROsol - Helically Corrugated Steel Pipes, Round and Arch Profiles](https://www.pft-uft.cz/storage/app/media/Spirosol_corrugated_steel_10-08-2017.pdf)
**Localizador exacto:** PDF y pagina impresa 7/20; encabezado `Plate thickness and corrugation`; dibujo `76 x 25 mm`; filas encabezadas `76 x 25`.
**SHA-256 del PDF consultado:** `ddb0940763c1acba2c655aade5f7513c4ecbfbceae26248653a72c0cb14cb90c`.

La geometria publicada es paso 76 mm, profundidad pico-valle 25 mm y radio R14. Las unicas filas del perfil son:

| `t` publicado como plate thickness | `F` area | `I` | `W` modulo resistente |
|---:|---:|---:|---:|
| 1,5 mm | 1,86 mm2/mm | 140,1 mm4/mm | 10,4 mm3/mm |
| 2,0 mm | 2,36 mm2/mm | 178,7 mm4/mm | 13,1 mm3/mm |
| 2,7 mm | 3,36 mm2/mm | 257,6 mm4/mm | 18,3 mm3/mm |

El catalogo limita la banda de acero a 1,2-2,7 mm; no publica 2,8, 3,0 ni 3,5 mm para este producto. Publica espesores de zinc Z600, Z725 y Z1000 por cara, pero no define expresamente si `t` en la tabla se mide antes o despues del recubrimiento; esa relacion queda `UNKNOWN`. Estas propiedades no se extrapolan ni se mezclan con CSPI.

### D. Comprobacion independiente de que no existe fila 3,0 para 76 x 25

**Editor:** CSPI.
**Fuente:** [Modern Sewer Design - Chapter 7](https://cspi.ca/wp-content/uploads/2021/04/ModernSewer_Chapter7.pdf)
**Localizador exacto:** PDF fisico 8/28; pagina impresa 199; **Table 7.4**, encabezado `Moment of inertia (I) and cross-sectional area (A) of corrugated steel for underground conduits`; filas `76 x 25`.
**SHA-256 del PDF consultado:** `dfbcf6cc7226f454d671fba29a54683c942bb9f4c14278faed93e7c9af13cc88`.

La tabla repite para 76 x 25 los valores `I/A` de 2,8, 3,5 y 4,2 mm de la Table 2.4. La columna general `3.0` esta vacia en la fila 76 x 25; los valores que aparecen bajo 3,0 pertenecen al perfil 152 x 51. No deben desplazarse visualmente de columna.

## Runs

- Se abrieron los cuatro PDF desde sus enlaces directos el 2026-08-13.
- Se renderizaron e inspeccionaron visualmente las paginas que contienen Figure 2.1, CSPI Table 2.4, Modern Sewer Table 7.4 y CSA Tables 3, 6 y A.1. Esta inspeccion confirma radios, encabezados, celdas vacias y alineacion de columnas.
- Se extrajo texto conservando el layout para comprobar que la columna `3.0` de Modern Sewer esta vacia en la fila 76 x 25.
- Los valores de `A` e `I` de CSPI Table 2.4 coinciden exactamente con Modern Sewer Table 7.4 para 2,8 y 3,5 mm.
- No se ejecuto ningun calculo del proyecto y no se modifico ningun consumidor del modelo. La validacion aceptada de este checkpoint es documental y visual.

## No-replay

- No volver a la tabla NCSPA 2018 `3 x 1 in`, ni a sus espesores convertidos, ni a una interpolacion a 3,0 mm.
- No leer el `3.0` del encabezado general de Modern Sewer como si tuviera una celda para 76 x 25.
- No usar la fila `3.00 -> 2.84` de CSA Table A.2: es otra familia de producto.
- No llamar `base thickness` a 2,8 o 3,5 mm dentro de la rama CSP; son espesores especificados/nominales. Los espesores base de diseño son 2,64 y 3,35 mm.
- No declarar que CSPI y SPIROsol son la misma onda. CSPI publica 76,2/25,4/R14,29; BCT publica 76/25/R14.
- No derivar, interpolar ni extrapolar una fila de 3,0 mm entre 2,8 y 3,5.
- No copiar el PDF licenciado de CSA al repositorio.

## Next

**Siguiente accion segura exacta:** antes de editar la referencia seccional, clasificar documentalmente el producto y el dato `t0 = 3,0 mm`.

1. Confirmar si el revestimiento es CSP corrugado anular/helicoidal, structural plate, tunnel liner plate u otro producto de fabricante.
2. Confirmar si 3,0 mm es nominal con recubrimiento, acero base medido, acero base de diseño o espesor total recubierto.
3. Si se adopta CSPI/CSA CSP, elegir explicitamente una sola fila:
   - `specifiedThicknessMm = 2,8` y `designBaseThicknessMm = 2,64`; o
   - `specifiedThicknessMm = 3,5` y `designBaseThicknessMm = 3,35`.
4. En esa rama, almacenar ambos espesores, las propiedades exactas publicadas y la geometria 76,2/25,4/R14,29 con `TL` y `theta`; eliminar la interpolacion del camino activo.
5. Si el producto real exige la geometria BCT exacta 76/25/R14, detener la seleccion: ninguna de las dos filas candidatas esta publicada para SPIROsol. Obtener ficha del fabricante o calcular analiticamente solo despues de cerrar la geometria y la semantica del espesor.
6. Recalcular y revalidar el reporte solamente despues de esa decision. Hasta entonces, `A`, `I`, rigideces y resultados dependientes continúan condicionados.

**Decision pendiente:** este handoff no recomienda 2,8 sobre 3,5 ni viceversa. La eleccion es una decision de identidad de producto y categoria de espesor, no una aproximacion numerica al valor 3,0.
