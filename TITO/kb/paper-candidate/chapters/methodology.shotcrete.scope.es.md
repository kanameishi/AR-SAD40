# Alternativa de revestimiento de hormigón proyectado

## Objeto y alcance

Esta metodología establece la comprobación seccional de un revestimiento
circular de hormigón proyectado sometido a las resultantes seccionales
$N_\theta$, $M_\theta$ y $Q_\theta$. El análisis se formula para una sección
transversal plana y una franja longitudinal de ancho declarado.

La formulación considera inicialmente un revestimiento de hormigón proyectado
que constituye un sistema resistente autónomo. Las resultantes de una chapa
existente no se transfieren directamente a esta sección: la respuesta de la
sección transversal debe calcularse nuevamente con la geometría, las rigideces
y la trayectoria de carga que correspondan al revestimiento de hormigón. Si se
pretende que el hormigón proyectado y la chapa trabajen conjuntamente, deben
establecerse la transferencia de corte en la interfaz, el posible deslizamiento,
la secuencia constructiva y el reparto de acciones. Esa situación requiere una
formulación específica y no está incluida aquí.

El procedimiento comprende:

1. definición de la base reglamentaria y de la tipología estructural;
2. caracterización de la geometría resistente y de los materiales existentes;
3. cálculo de las resultantes $N_\theta$, $M_\theta$ y $Q_\theta$ con las
   rigideces del sistema analizado;
4. transformación de las resultantes por unidad de longitud a las acciones de
   una franja de cálculo;
5. clasificación reglamentaria de la sección como hormigón simple, armado o
   reforzado con fibras;
6. comprobación de flexocompresión y corte mediante la formulación aplicable;
7. determinación de la condición gobernante a lo largo de la circunferencia; y
8. comprobaciones independientes de servicio, durabilidad, estabilidad,
   juntas y anclajes.

## Condiciones previas de aplicación

La Resolución SOP 11/2026 puso en vigencia nacional CIRSOC 200-24 y CIRSOC
201-25 a partir del 22 de enero de 2026 e invitó a las jurisdicciones locales a
adherir [@SOP112026]. La jurisdicción, la adhesión y la base contractual de la
obra deben comprobarse antes de adoptar esos Reglamentos.

CIRSOC 201-25 excluye de su campo de validez el diseño de cáscaras delgadas y
estructuras de placas plegadas. El mismo Reglamento contempla condiciones de
aplicación básica o complementaria a otras estructuras. CIRSOC 804-4 es el
Reglamento específico de estructuras enterradas y revestimientos para túneles,
pero su artículo 12.1 no identifica expresamente un revestimiento circular de
hormigón proyectado [@CIRSOC20125, arts. 1.2.2, 1.2.10.7 y 1.2.11;
@CIRSOC8044, art. 12.1]. En consecuencia, antes de efectuar una comprobación
reglamentaria se debe documentar:

- si el análisis local se admite como el de una franja o arco, o si resulta
  aplicable la exclusión correspondiente a cáscaras delgadas;
- si CIRSOC 201-25 se adopta como Reglamento básico o complementario;
- qué disposiciones de CIRSOC 804-4 gobiernan el revestimiento; y
- la edición y los artículos contractualmente exigibles.

CIRSOC 200-24 regula la tecnología, la ejecución y la aceptación del hormigón
proyectado. Su artículo 9.4 tiene alcance directo para el proceso por vía húmeda
utilizado como soporte del terreno; la aplicación a la vía seca exige considerar
las particularidades del proceso [@CIRSOC20024, art. 9.4.1.1 y comentario]. La
identificación de la vía de proyección es, por tanto, un dato necesario, pero no
modifica por sí misma las ecuaciones de equilibrio y compatibilidad de la
sección.

## Clasificación de la sección

La presencia o ausencia de una armadura no selecciona por sí sola la
formulación resistente. CIRSOC 201-25 incluye dentro del hormigón simple al
hormigón cuya armadura es inferior a la mínima especificada para hormigón
armado [@CIRSOC20125, art. 2.1]. La clasificación debe sustentarse en la
tipología del elemento, las cuantías mínimas, el detallado y las disposiciones
aplicables:

- **hormigón simple**: requiere demostrar la aplicabilidad del capítulo 14,
  aunque exista armadura discreta;
- **hormigón armado**: requiere satisfacer los mínimos y el detallado que
  correspondan al elemento; y
- **hormigón reforzado con fibras**: requiere propiedades residuales medidas y
  una formulación normativa específica.

La formulación inicial cubre hormigón simple y hormigón armado convencional.
La contribución postfisuración de fibras no se incorpora mientras no se
disponga de propiedades residuales, método de ensayo y base normativa
aprobados.

## Estructura existente

La evaluación de una estructura existente debe emplear dimensiones y
propiedades verificadas en campo. El espesor resistente excluye vacíos,
delaminaciones y material sin transferencia demostrada; la posición y el área
neta de las armaduras se determinan para cada capa. La corrosión reduce el área
de acero y no el espesor de hormigón.

La resistencia efectiva empleada durante la producción y aceptación del
hormigón proyectado no se sustituye automáticamente por una propiedad de
diseño. La comprobación resistente utiliza una resistencia especificada
equivalente $f'_{c,\mathrm{eq}}$ obtenida mediante el procedimiento estadístico
adoptado para la estructura existente, con trazabilidad a los testigos, sus
localizaciones y sus condiciones de ensayo [@CIRSOC20024, arts. 6.5 y 9.4;
@CIRSOC20125, arts. 27.3.1.1--27.3.1.5].

## Límites

La comprobación seccional no demuestra por sí sola:

- estabilidad del revestimiento como arco o cáscara;
- efectos de segundo orden;
- acción compuesta con la chapa existente;
- resistencia postfisuración de hormigón con fibras;
- transferencia en juntas o interfaces;
- fisuración, estanqueidad y deformaciones en servicio;
- durabilidad, recubrimiento y vida remanente; ni
- aptitud de anclajes, empalmes y discontinuidades.

Estas verificaciones se presentan como estados separados y no se sustituyen
por un único cociente capacidad--demanda.
