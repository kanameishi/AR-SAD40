# Alternativa de revestimiento de hormigón proyectado

## Objeto

Esta metodología establece el procedimiento para analizar secciones circulares de hormigón proyectado y comprobar una franja longitudinal sometida a las resultantes circunferenciales $N_\theta$, $M_\theta$ y $Q_\theta$. Las secciones autónomas se clasifican como hormigón simple u hormigón armado. El estudio paramétrico incorpora además una sección compuesta explícita formada por la chapa existente y una malla interior.

En las secciones autónomas no se transfieren solicitaciones desde la chapa existente. Para cada combinación se calculan el radio, las razones $C^*$ y
$F^*$ y las distribuciones angulares de las tres resultantes. La carga externa de Schwartz--Einstein aporta los modos $n=0,2$ y la corrección equilibrada del gradiente aporta $n=1,3$. El procedimiento se ejecuta para deslizamiento libre y sin deslizamiento. La proyección del estado biaxial uniforme, la integración directa y Fourier se conservan como controles separados de carga prescrita.

La sección compuesta adopta compatibilidad total entre la chapa, el hormigón y la armadura interior. Su centroide y sus rigideces se determinan con los tres componentes y las resultantes se recalculan antes de construir el dominio
$P$--$M$. Esta hipótesis exige transferencia completa de corte en la interfaz y se presenta separadamente de las secciones autónomas.

## Referencias normativas

La familia internacional adoptada es ACI:

- ACI CODE-318-25 proporciona las disposiciones de resistencia seccional, servicio, durabilidad y detallado. El Capítulo 14 contiene la comprobación adoptada para la rama de hormigón simple [@ACI31825]. Las combinaciones de acciones proceden de la envolvente EV--EH de AASHTO/CIRSOC utilizada para estructuras enterradas rígidas.
- ACI CODE-318.2-25 gobierna cuando el revestimiento de hormigón armado se clasifica como cáscara delgada; ACI CODE-318-25 actúa entonces como documento complementario [@ACI318225; @ACI31825].
- ACI CODE-562-25 establece el marco para evaluar una estructura existente, incluidas la investigación de campo, las propiedades medidas, el deterioro y los factores de evaluación que correspondan [@ACI56225].
- ACI SPEC-506.2-13 (18) regula los materiales, la ejecución, los ensayos y la aceptación del hormigón proyectado; no sustituye la comprobación resistente de la sección [@ACISPEC506213].

La evaluación de fisuración se distingue de la resistencia. Los requisitos contractuales de ejecución y aceptación del shotcrete se verifican asimismo por separado de la resistencia seccional.

## Clasificación estructural

La clasificación declarada de la sección selecciona expresamente una de dos ramas:

1. hormigón simple: comprobación local conforme al Capítulo 14 de ACI CODE-318-25, condicionada por el tipo de miembro, el apoyo, la categoría sísmica, las juntas y las aberturas;
2. hormigón armado: compatibilidad y equilibrio de una sección con capas de armadura, complementados por las disposiciones de ACI CODE-318.2-25 que correspondan a una cáscara delgada.

La rama no se infiere a partir del área de acero. En particular, $A_s=0$ es una característica válida de una sección declarada como hormigón simple y no activa un control de cuantía mínima de hormigón armado. Inversamente, una sección declarada como armada debe satisfacer las cuantías, la disposición y el detallado exigibles aunque el equilibrio seccional resulte satisfactorio.

## Definición de acciones

Las combinaciones resistentes se forman sobre las componentes vertical y horizontal del estado tensional del relleno. Para cada par de factores
$(\gamma_v,\gamma_h)$ se resuelve nuevamente la respuesta de la sección transversal:

$$
\sigma'_{v,d}=\gamma_v\sigma'_v, \qquad \sigma'_{h,d}=\gamma_h\sigma'_h,
$$

y de esa resolución se obtienen $N_\theta (\theta)$,
$M_\theta (\theta)$ y $Q_\theta (\theta)$. No se aplican factores a máximos espaciales independientes ni se combinan valores correspondientes a ángulos distintos. Cada fila de comprobación conserva una única combinación, una condición de interfaz y una posición $\theta$.

## Estructura existente

La sección resistente se define con dimensiones y propiedades verificadas. El espesor excluye vacíos, delaminaciones y material cuya transferencia no esté demostrada. Las armaduras se representan mediante áreas netas y posiciones por capa; una cuantía global en cm²/m no define el brazo mecánico. La corrosión de las barras reduce su área y debe conservarse separada de cualquier pérdida del espesor de hormigón.

La resistencia de diseño del hormigón existente se adopta mediante el procedimiento de evaluación y ensayos aprobado conforme a ACI CODE-562-25. La función seccional recibe ese valor y su procedencia; no transforma por sí sola resultados de testigos en una resistencia de diseño.

## Secuencia de comprobación

1. definir la geometría, las propiedades y la rama resistente de la sección;
2. calcular su centroide y su rigidez circunferencial, incluyendo los componentes de la sección compuesta cuando corresponda;
3. formar cada combinación de acciones sobre el estado tensional del relleno;
4. resolver Schwartz--Einstein para deslizamiento libre y sin deslizamiento, con el radio y las rigideces de la alternativa;
5. transformar las resultantes concurrentes en acciones sobre una franja de ancho declarado;
6. aplicar las comprobaciones de resistencia correspondientes a la rama seleccionada; y
7. informar separadamente resistencia local, estabilidad, servicio, durabilidad, juntas, aberturas y requisitos constructivos.

## Alcance del procedimiento vigente

La rama de hormigón simple implementa las comprobaciones locales de tracción, compresión y corte del Capítulo 14 de ACI CODE-318-25 para acciones mayoradas. La resistencia axial requiere una longitud de compresión documentada. La estabilidad global, la categoría sísmica, las juntas, las aberturas, la durabilidad y el servicio conservan controles independientes.

La selección de esta rama requiere acreditar la clasificación estructural del revestimiento y una de las condiciones de ACI CODE-318-25, 14.1.2. La aplicabilidad exige comprobar que la estructura puede representarse mediante arcos bidimensionales y que dispone del apoyo requerido. Las razones de utilización del Capítulo 14 corresponden a la comprobación seccional; la clasificación y el apoyo conservan verificaciones independientes.

La rama de hormigón armado implementa el dominio $P$--$M$ mediante compatibilidad, equilibrio y factores $\phi$ de ACI CODE-318-25. La cuantía mínima total por dirección se comprueba separadamente mediante ACI 318.2-14, 6.1.3; la distribución simétrica entre caras es una configuración del estudio, no una armadura adoptada. La sección compuesta emplea el mismo equilibrio seccional con la chapa como capa exterior de acero y recalcula sus demandas. Las demás comprobaciones de una cáscara delgada se establecen con el articulado aplicable de ACI CODE-318.2-25.
