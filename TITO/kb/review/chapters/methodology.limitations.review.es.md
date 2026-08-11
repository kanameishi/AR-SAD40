# Aplicación al revestimiento existente

## Información requerida

La determinación de las resultantes seccionales exige definir la geometría
resistente, el estado de tensiones del relleno, las acciones constructivas y
las condiciones hidráulicas. Los siguientes antecedentes deben verificarse
antes de adoptar una envolvente de demanda.

### Geometría y propiedades de la sección

- diámetro interior y radio del eje centroidal de la chapa;
- ovalización inicial y variación geométrica a lo largo del conducto;
- paso, altura y orientación de la corrugación;
- espesor base y pérdidas de espesor representativas;
- ubicación de solapes, juntas y otras discontinuidades;
- módulo de elasticidad o especificación del acero.

La geometría confirmada se incorpora como dato determinista. Mientras un
parámetro geométrico permanezca sin confirmar, se lo evalúa mediante valores
nominales alternativos claramente identificados y separados de la
variabilidad aleatoria de las propiedades del relleno.

### Relleno y condición hidráulica

- estratigrafía y clasificación del relleno y del terreno adyacente;
- pesos unitarios, humedad, densidad y grado de compactación;
- ángulo de fricción efectiva, historia tensional y antecedentes para
  establecer $K_0$;
- cota piezométrica exterior, presión interior y sus variaciones;
- sobrecargas permanentes y transitorias.

### Proceso constructivo

- secuencia, espesor y cota de las tongadas;
- tipo, fuerza y posición del equipo de compactación;
- procedimiento empleado para controlar la ovalización durante el relleno;
- características del material en contacto con la chapa;
- mediciones de deformación efectuadas durante y después de la instalación.

Estos antecedentes permiten establecer si la proyección completa del estado
biaxial, la carga exclusivamente normal u otra formulación de interacción
representa adecuadamente cada etapa. Los dos primeros casos son estados de
carga prescrita. La determinación de una tracción parcial a partir de un
coeficiente de fricción requiere una ley constitutiva de interfaz adicional.

## Procedimiento de cálculo

La aplicación se organiza en la siguiente secuencia:

1. **Definición de la sección transversal.** Se establece el radio centroidal
   y se calculan $A_p$, $I_p$, $EA_\theta$, $EI_\theta$ y $\eta_s$.
2. **Caracterización del estado tensional.** Se integra $\sigma'_v(z)$, se
   define $\Delta u(z)$ y se determina el estado lateral del relleno.
3. **Definición de estados de carga.** El estado permanente, las etapas de
   compactación, las sobrecargas y las condiciones hidráulicas se evalúan por
   separado.
4. **Transformación de las acciones.** Cada estado se expresa mediante
   $P_r(\theta)$ y $P_t(\theta)$, con origen angular y signos explícitos.
5. **Control del equilibrio global.** Las dos componentes de fuerza y el
   momento resultante se verifican antes de resolver la respuesta transversal.
6. **Cálculo de las resultantes.** La integración directa entrega
   $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$; la
   representación de Fourier proporciona un control modal para cargas
   periódicas.
7. **Propagación de incertidumbres.** Las realizaciones Monte Carlo producen
   cuantiles puntuales y distribuciones de extremos espaciales.
8. **Identificación de estados gobernantes.** Cada extremo se registra junto
   con su magnitud, signo, posición angular, etapa constructiva y realización.
9. **Contraste con referencias.** La componente uniforme de fuerza normal se
   compara con la relación USACE. Schwartz--Einstein y Núñez se evalúan con las
   hipótesis y convenciones de sus respectivos dominios.

CANDE documenta una alternativa de análisis acoplado. Una comparación
cuantitativa con la formulación de cargas prescritas requiere un caso común con
la misma geometría, propiedades, secuencia y convenciones, cuyo desarrollo
queda fuera del alcance aquí establecido.

## Límites de la formulación transversal

La solución desarrollada representa una sección invariante en la dirección
longitudinal. Incluye compresión circunferencial, flexión en el plano de la
sección y fuerza cortante para distribuciones perimetrales autoequilibradas.
El estado biaxial uniforme a la cota del eje y las franjas laterales simétricas
de compactación satisfacen esta condición.

Un gradiente de presión sobre el diámetro puede producir una resultante global.
Ese estado exige definir, dentro del mismo sistema de cargas, el peso propio, la
flotación y las reacciones de apoyo que completan el equilibrio. El alcance
desarrollado comprende exclusivamente distribuciones autoequilibradas.

Las zonas próximas a extremos, transiciones, aberturas, juntas
circunferenciales, cargas que varían longitudinalmente y corrugaciones
helicoidales quedan fuera del modelo plano. Su evaluación requiere una
formulación espacial específica.

# Conclusiones de la formulación

La respuesta transversal del revestimiento queda determinada, para una carga
perimetral prescrita y autoequilibrada, por las ecuaciones de equilibrio de la
viga curva y tres condiciones de compatibilidad. La integración directa admite
distribuciones continuas o discontinuas; la solución modal permite comprobar
los estados representables mediante series de Fourier.

Para un estado biaxial uniforme, la componente uniforme de la fuerza normal
circunferencial depende de $(1+K_0)\sigma'_{v,A}$. Las amplitudes de
$M_\theta$, $Q_\theta$ y de la componente de orden dos de $N_\theta$ dependen de
$\lvert1-K_0\rvert\sigma'_{v,A}$. La proyección completa y la carga
exclusivamente normal producen respuestas diferentes porque prescriben
distintas componentes del vector de tracción. Las condiciones constitutivas de
interfaz se establecen mediante una relación independiente.

La corrugación se incorpora mediante las rigideces circunferenciales
$EA_\theta$ y $EI_\theta$ de una viga curva por unidad de longitud
axial. Esta idealización modifica la compatibilidad del modo uniforme y
conserva como resultados únicamente $N_\theta$, $M_\theta$ y $Q_\theta$; la
evaluación de tensiones en la chapa y de fuerzas en las uniones corresponde a
una etapa posterior.

El ejemplo analítico para el estado biaxial uniforme establece la localización
de los extremos de ese caso. La demanda del revestimiento existente sólo podrá definirse
después de confirmar la geometría seccional y caracterizar el relleno, el
estado hidráulico y la secuencia de compactación.
