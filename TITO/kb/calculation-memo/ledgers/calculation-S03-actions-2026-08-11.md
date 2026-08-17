# report-calculation-S03-actions-2026-08-11

## Section

Estado tensional efectivo, acciones del relleno e interacción externa.

## Report Purpose

Identificar el estado tensional de campo libre y la secuencia de interacción
empleados por la aplicación, manteniendo separadas la comprobación escalar
AASHTO y el estado biaxial de control.

## Sources Read

Christopher et al. (2006); Mayne y Kulhawy (1982); índice oficial de AASHTO
LRFD 10.ª edición; AASHTO LRFD Bridge Construction Specifications; USACE
(2020); documento metodológico aprobado. Michalowski (2005) se leyó para
contrastar la forma original de Jáky, excluida de la memoria y reservada para
el desarrollo académico.

## Exact Claims Allowed

La rama reglamentaria se selecciona entre los artículos 12.7, 12.8 y 12.13 de
AASHTO después de clasificar el producto; el subartículo 12.8.9 se aplica
cuando corresponde a una estructura de corrugación profunda. USACE reproduce
$T_L=P_FS/2$ como referencia pública para conductos metálicos. La tensión vertical efectiva varía con la profundidad y se integra por
estratos. $K_0$ relaciona tensiones efectivas y se obtiene de una única rama
compatible con el material y la trayectoria tensional. Las relaciones de
Mayne--Kulhawy representan descarga primaria y descarga seguida de recarga;
su límite pasivo controla el dominio de aplicación. Schwartz--Einstein utiliza
el estado efectivo en la cota del eje y las rigideces de cada revestimiento
para obtener sus resultantes. USACE contrasta separadamente la componente
escalar de empuje.

## Claims Not Allowed

No incorporar la presión equivalente de compactación de FHWA como incremento
de $K_0$, presión residual o acción del estado permanente. No emplear la
transcripción de FHWA NHI-05-037,
ec. 5.39, para la recarga; no habilitar la forma de Jáky de 1944,
Brooker--Ireland, Mesri--Hayat ni una tensión residual de compactación sin un
modelo aplicable. No identificar $K_0\sigma'_v$ con la presión de contacto ni
atribuir $M_\theta$ o $Q_\theta$ a la ecuación reglamentaria escalar.

## Equations Allowed

Profundidad, tensión vertical, presión intersticial;
`eq-calculation-k0`, `eq-calculation-k0-reference`,
`eq-calculation-k0-unloading`, `eq-calculation-k0-reloading`,
`eq-calculation-k0-passive-limit`; `eq-calculation-standard-thrust` como
relación USACE sujeta a comprobación AASHTO; y ecuaciones de interacción
externa de Schwartz--Einstein.

## Equations Excluded

FHWA NHI-05-037, ecuación 5.39, para recarga; forma de Jáky de 1944;
Brooker--Ireland; Mesri--Hayat; y cualquier expresión cuantitativa de tensión
residual de compactación que carezca de un modelo aplicable al revestimiento.

## Vocabulary Allowed

Tensión efectiva; presión intersticial; empuje en reposo; estado de campo
libre; interacción externa; estado constructivo separado.

## Vocabulary Rejected

Coeficiente de fricción para designar $\alpha$; presión residual FHWA para
designar una acción temporal por etapa; coeficiente de compactación para
designar indistintamente $K_0$, OCR o $\Delta\sigma'_{h,c}$.

## Candidate Public Paragraph Or Section

`TITO/kb/calculation-memo/chapters/calculation.actions.review.es.md`.

## Candidate Translation Terminology

None — la sección se redactó directamente en español; las siglas OCR y los
símbolos matemáticos conservan la notación de las fuentes.

## Open Gaps

Clasificación del producto, articulado AASHTO, $P_F$, $S$, formulación de interacción,
estratigrafía, agua, trayectoria tensional, OCR,
$\mathrm{OCR}_{\max}$ y secuencia constructiva real. El tratamiento de una
acción temporal de compactación se conserva en la metodología ampliada y no en
la aplicación determinística de la memoria.

## Validation

CANDIDATO CORREGIDO EL 15 DE AGOSTO DE 2026; ACCIÓN DE COMPACTACIÓN RETIRADA
DEL ESTADO PERMANENTE Y DOCUMENTADA EN LA METODOLOGÍA; ENSAMBLADO RENDERIZADO
Y AUDITORÍA EDITORIAL CONCLUIDA `PASS`.
