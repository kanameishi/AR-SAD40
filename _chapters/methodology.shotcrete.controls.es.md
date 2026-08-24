# Apéndice D. Controles y datos requeridos {#sec-methodology-shotcrete-controls .unnumbered}

## D.1 Controles del cálculo de acciones {.unnumbered}

Para cada combinación y condición de interfaz se comprueba:

- correspondencia entre los factores vertical y horizontal declarados y el estado tensional utilizado para resolver la interacción;
- conservación de una misma combinación, etapa y posición angular en $N_\theta$, $M_\theta$ y $Q_\theta$;
- uso de la geometría y la rigidez propias de la alternativa de hormigón;
- equilibrio y cierre periódico de las distribuciones angulares; y
- correspondencia de unidades entre kN/m, kN·m/m, N y N·mm.

## D.2 Controles de hormigón simple {.unnumbered}

La aplicación del Capítulo 14 requiere documentar:

| Componente       | Dato o condición                                                          |
|------------------|---------------------------------------------------------------------------|
| sección          | $b$, $h$, condición de colocación contra suelo y espesor de cálculo $h_d$ |
| hormigón         | $f'_c$, $\lambda$ y procedencia de las propiedades                        |
| acciones         | $P_u$, $M_u$ y $V_u$ mayorados y concurrentes                             |
| compresión       | longitud $\ell_c$ utilizada en la Ecuación 14.5.3.1                       |
| aplicabilidad    | tipología estructural y base que habilita hormigón simple                 |
| alcance sísmico  | categoría de diseño sísmico                                               |
| discontinuidades | disposición de juntas y tratamiento de continuidad flexional              |
| aberturas        | ausencia de aberturas o detalle conforme alrededor de ellas               |

Los controles numéricos mínimos comprenden fuerza axial pura, flexión pura, corte puro, inversión del signo del momento y coincidencia entre la fila gobernante y el máximo de cada utilización. Una acción no mayorada no se compara con una resistencia de diseño.

La ausencia de armadura no constituye un incumplimiento de esta rama. Las cuantías mínimas y el detallado de armaduras sólo se aplican cuando la sección se clasifica como hormigón armado.

## D.3 Controles de hormigón armado {.unnumbered}

El núcleo seccional armado se comprueba mediante:

- equilibrio de fuerzas y momentos para cada estado de deformación;
- simetría del dominio respecto de $M=0$ para secciones simétricas;
- inversión coherente de $M$ al intercambiar las caras;
- convergencia respecto de la discretización del contorno; y
- reproducción de estados elementales de fuerza normal y flexión.

La cuantía se controla como total por dirección; no se confunde ese total con el área de cada cara. Cuando se adopta una distribución simétrica, se comprueba además la igualdad de las áreas interior y exterior y la presencia de una armadura ortogonal independiente. La resistencia del acero, las coordenadas de las capas y el módulo elástico son primitivas de la sección, no valores deducidos de la cuantía total.

Estas verificaciones comprueban la compatibilidad, el equilibrio y el control separado de cuantía mínima; no adoptan una malla. Las demandas de cáscara, el corte, la acción longitudinal, la estabilidad y el detallado se evalúan con el articulado aplicable de ACI CODE-318.2-25.

## D.4 Comprobaciones independientes {.unnumbered}

La resistencia local se informa separadamente de:

- estabilidad global y efectos de segundo orden;
- durabilidad, exposición y recubrimiento;
- fisuración y deformaciones en servicio;
- juntas, aberturas y anclajes;
- transferencia con la chapa existente; y
- materiales, ejecución, ensayos y aceptación del hormigón proyectado.

Cuando una de estas condiciones no está caracterizada, sólo queda pendiente esa comprobación. Los controles resistentes que puedan calcularse con datos suficientes conservan su resultado, incluido cualquier incumplimiento.
