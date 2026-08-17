# Registro de sección — alternativa de hormigón proyectado

## Sección

Base ACI condicionada, caracterización de una estructura existente y
comprobación seccional de un revestimiento circular autónomo de hormigón
proyectado.

## Finalidad

Establecer el análisis autónomo de un revestimiento circular de hormigón
proyectado y comprobar sus resultantes concurrentes $N_\theta$, $M_\theta$ y
$Q_\theta$ mediante ramas separadas de hormigón simple y hormigón armado.

## Fuentes leídas

- índice y alcance oficiales de ACI CODE-318.2-25;
- texto completo en unidades SI de ACI CODE-318-25;
- alcance oficial de ACI CODE-562-25;
- alcance oficial de ACI SPEC-506.2-13(18); y
- `TITO/kb/research/g10.aci.concrete.section.verification.es.md`.

La vista oficial de ACI CODE-318.2-25 y su huella digital están registradas en
`TITO/kb/MANIFEST.md`. El informe CIRSOC anterior se conserva únicamente como
antecedente histórico no gobernante en
`TITO/kb/research/g10.shotcrete.section.verification.es.md`.

## Afirmaciones admitidas

- ACI CODE-318.2-25 gobierna cuando el revestimiento se clasifica como una
  cáscara delgada; ACI CODE-318-25 lo complementa.
- ACI CODE-562-25 proporciona el marco para evaluar una estructura existente.
- ACI SPEC-506.2-13(18) regula materiales, ejecución, ensayos y aceptación del
  shotcrete; no sustituye la comprobación resistente.
- Una alternativa autónoma de hormigón proyectado requiere recalcular
  $N_\theta$, $M_\theta$ y $Q_\theta$ con sus propias rigideces.
- La clasificación resistente se declara explícitamente; $A_s=0$ no es un
  incumplimiento de la rama de hormigón simple ni selecciona por sí solo esa
  rama.
- ACI 318-25, Capítulo 14, permite ejecutar las comprobaciones locales de
  tracción, compresión y corte de la rama simple, sujetas a sus condiciones de
  aplicabilidad.

## Afirmaciones excluidas

- aplicación de coeficientes CIRSOC bajo una etiqueta ACI;
- ecuaciones de capacidad, deformaciones límite, factores de reducción o
  cuantías mínimas no comprobados en el articulado aplicable;
- acción compuesta entre chapa y hormigón sin demostrar interfaz, adherencia,
  secuencia y transferencia;
- contribución postfisuración de fibras sin propiedades residuales y una
  formulación normativa aplicable; y
- resultados de capacidad, utilización o reserva con valores supuestos.

## Ecuaciones admitidas

- transformación explícita de $N_\theta$, $M_\theta$ y $Q_\theta$ concurrentes
  a las acciones de una franja longitudinal declarada;
- resistencia local de hormigón simple conforme a ACI 318-25, Capítulo 14;
- compatibilidad de deformaciones planas para hormigón armado; y
- equilibrio integral de fuerza normal y momento para la sección armada.

Estas relaciones son de mecánica seccional. No constituyen por sí mismas una
comprobación ACI.

## Capítulos candidatos

- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.scope.es.md`;
- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.section.es.md`; y
- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.controls.es.md`.

## Datos pendientes

Texto completo aplicable de ACI CODE-318.2-25 para la rama armada; longitud de
compresión $\ell_c$; categoría sísmica; juntas; aberturas; estabilidad global;
exposición, durabilidad y servicio; resistencia de diseño del hormigón
existente; y, para futuras secciones armadas o con fibras, capas y propiedades
residuales comprobadas.

## Estado

La comprobación local de hormigón simple es ejecutable con ACI 318-25 y se
aplica a cada condición de interfaz y combinación mayorada. La comprobación de
la cara comprimida requiere $\ell_c$ documentada. El dictamen integral de una
cáscara armada permanece condicionado por ACI CODE-318.2-25 y por los datos
indicados.
