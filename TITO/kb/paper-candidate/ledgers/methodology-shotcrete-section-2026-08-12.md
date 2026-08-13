# Registro de sección — alternativa de hormigón proyectado

## Sección

Base ACI condicionada, caracterización de una estructura existente y
comprobación seccional de un revestimiento circular autónomo de hormigón
proyectado.

## Finalidad

Establecer una comprobación de fuerza normal y momento flector para una
sección arbitraria, independiente del modelo que produjo las solicitaciones,
y separar el núcleo mecánico de las disposiciones resistentes que dependen de
la clasificación y del articulado ACI aplicable.

## Fuentes leídas

- índice y alcance oficiales de ACI CODE-318.2-25;
- portal oficial de ACI CODE-318-25;
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
- La clasificación y la armadura mínima preceden a la selección de una rama
  resistente; $A_s=0$ no demuestra que el hormigón simple sea admisible.

## Afirmaciones excluidas

- aplicación de coeficientes CIRSOC bajo una etiqueta ACI;
- ecuaciones de capacidad, deformaciones límite, factores de reducción o
  cuantías mínimas no comprobados en el articulado vigente;
- acción compuesta entre chapa y hormigón sin demostrar interfaz, adherencia,
  secuencia y transferencia;
- contribución postfisuración de fibras sin propiedades residuales y una
  formulación normativa aplicable; y
- resultados de capacidad, utilización o reserva con valores supuestos.

## Ecuaciones admitidas

- transformación explícita de $N_\theta$, $M_\theta$ y $Q_\theta$ a las
  acciones de una franja longitudinal declarada;
- compatibilidad de deformaciones planas; y
- equilibrio integral de fuerza normal y momento para leyes constitutivas que
  se definan posteriormente desde el articulado ACI aplicable.

Estas relaciones son de mecánica seccional. No constituyen por sí mismas una
comprobación ACI.

## Capítulos candidatos

- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.scope.es.md`;
- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.section.es.md`; y
- `TITO/kb/paper-candidate/chapters/methodology.shotcrete.controls.es.md`.

## Datos pendientes

Clasificación frente a ACI CODE-318.2-25; articulado vigente en SI de ACI
318.2, ACI 318 y ACI 562; alternativa autónoma o compuesta; combinaciones
últimas y de servicio; espesor resistente; defectos; juntas; resistencia de
diseño del hormigón existente; capas de armadura; propiedades residuales de
fibras; estabilidad, exposición, fisuración y estanqueidad.

## Estado

La arquitectura conceptual es admisible. La verificación ACI ejecutable
permanece bloqueada hasta cerrar la clasificación, el articulado y los datos
anteriores; no se informa capacidad ni cumplimiento del caso.
