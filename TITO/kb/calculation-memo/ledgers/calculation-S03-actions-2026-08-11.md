# report-calculation-S03-actions-2026-08-11

## Section

Acciones del relleno, agua, compactación y participación tangencial.

## Report Purpose

Obtener $P_r(\theta)$ y $P_t(\theta)$ mediante relaciones finales que separen
tensiones efectivas, agua, historia de compactación y el multiplicador de la
componente tangencial proyectada.

## Sources Read

Christopher et al. (2006); Mayne y Kulhawy (1982); USACE (2020); McGrath et
al. (1999); documento metodológico aprobado. Michalowski (2005) se leyó para
contrastar la forma original de Jáky, excluida de la memoria y reservada para
el desarrollo académico.

## Exact Claims Allowed

La tensión vertical efectiva varía con la profundidad y se integra por
estratos. $K_0$ relaciona tensiones efectivas y se obtiene de una única rama
compatible con el material y la trayectoria tensional. Las relaciones de
Mayne--Kulhawy representan descarga primaria y descarga seguida de recarga;
su límite pasivo controla el dominio de aplicación. La proyección del estado
tensional define $p_n'$ y $p_t^*$. La acción tangencial satisface
$P_t=\alpha p_t^*$, con $0\leq\alpha\leq1$. USACE contrasta la componente
uniforme y FHWA define una acción equivalente de compactación.

## Claims Not Allowed

No identificar $\alpha$ con un coeficiente de fricción ni atribuirle una ley de
contacto; no adoptar retención permanente universal; no sumar ramas
incompatibles de compactación. No emplear la transcripción de FHWA NHI-05-037,
ec. 5.39, para la recarga; no habilitar la forma de Jáky de 1944,
Brooker--Ireland, Mesri--Hayat ni una tensión residual de compactación sin un
modelo aplicable.

## Equations Allowed

Profundidad, tensión vertical, presión intersticial;
`eq-calculation-k0`, `eq-calculation-k0-reference`,
`eq-calculation-k0-unloading`, `eq-calculation-k0-reloading`,
`eq-calculation-k0-passive-limit` y
`eq-calculation-compaction-history`; proyección del estado tensional,
multiplicador tangencial, USACE y acción temporal FHWA.

## Equations Excluded

FHWA NHI-05-037, ecuación 5.39, para recarga; forma de Jáky de 1944;
Brooker--Ireland; Mesri--Hayat; y cualquier expresión cuantitativa de tensión
residual de compactación que carezca de un modelo aplicable al revestimiento.

## Vocabulary Allowed

Tensión efectiva; presión intersticial; empuje en reposo; componente tangencial
proyectada; multiplicador tangencial; acción temporal de compactación.

## Vocabulary Rejected

Coeficiente de fricción para designar $\alpha$; presión residual FHWA para
designar una acción temporal por etapa; coeficiente de compactación para
designar indistintamente $K_0$, OCR o $\Delta\sigma'_{h,c}$.

## Candidate Public Paragraph Or Section

`TITO/kb/calculation-memo/chapters/calculation.actions.review.es.md`, desde
`sec-calculation-k0-estimation` hasta antes de «Transformación del estado
tensional y acciones perimetrales».

## Candidate Translation Terminology

None — la sección se redactó directamente en español; las siglas OCR y los
símbolos matemáticos conservan la notación de las fuentes.

## Open Gaps

Estratigrafía, agua, trayectoria tensional, OCR,
$\mathrm{OCR}_{\max}$, $\Delta\sigma'_{h,c}$, rango de $\alpha$ y secuencia
constructiva reales.

## Validation

APTO COMO FORMULACIÓN OPERATIVA; PARÁMETROS DEL CASO EXISTENTE PENDIENTES.
