# Aplicación al revestimiento existente

## Información requerida

La determinación de las resultantes seccionales exige definir la geometría
resistente, el estado de tensiones del relleno, las acciones constructivas y
las condiciones hidráulicas. Los siguientes antecedentes deben verificarse
antes de adoptar una envolvente de demanda.

Para definir la geometría y las propiedades de la sección se requieren:

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

Para caracterizar el relleno y la condición hidráulica se requieren:

- estratigrafía y clasificación del relleno y del terreno adyacente;
- pesos unitarios, humedad, densidad y grado de compactación;
- ángulo de fricción efectiva, historia tensional y antecedentes para
  establecer $K_0$;
- cota piezométrica exterior, presión interior y sus variaciones;
- sobrecargas permanentes y transitorias.

Para caracterizar el proceso constructivo se requieren:

- secuencia, espesor y cota de las tongadas;
- tipo, fuerza y posición del equipo de compactación;
- procedimiento empleado para controlar la ovalización durante el relleno;
- características del material en contacto con la chapa;
- mediciones de deformación efectuadas durante y después de la instalación.

Estos antecedentes permiten juzgar si los límites de Schwartz--Einstein
representan adecuadamente el estado permanente y si debe añadirse una etapa de
compactación. La proyección completa y la carga exclusivamente normal son
controles de carga prescrita, no leyes constitutivas de interfaz. Una tracción
parcial basada en fricción requeriría una relación adicional que no forma parte
de esta metodología.

## Procedimiento de cálculo

La aplicación se organiza en la siguiente secuencia:

1. **Definición de la sección transversal.** Se establece el radio centroidal
   y se calculan $A_p$, $I_p$, $K_N=E_\ell A_p$,
   $K_M=E_\ell I_p$ y $\eta_\ell$.
2. **Caracterización del estado tensional.** Se integra $\sigma'_v(z)$, se
   define $\Delta u(z)$ y se determina el estado lateral del relleno.
3. **Definición de estados de carga.** El estado permanente, las etapas de
   compactación, las sobrecargas y las condiciones hidráulicas se evalúan por
   separado.
4. **Cálculo interactivo.** Para cada sección se calculan $C^*$ y $F^*$ y se
   resuelve la carga externa de Schwartz--Einstein con deslizamiento libre y
   sin deslizamiento.
5. **Gradiente geostático.** La variación lineal entre clave y solera se
   proyecta en los modos $n=1,3$, se equilibra mediante la reacción radial de
   orden uno y se superpone a la componente uniforme.
6. **Control de carga prescrita.** El estado biaxial uniforme se expresa mediante
   $P_r(\theta)$ y $P_t(\theta)$, se controla su equilibrio global y se integra
   mediante RK4.
7. **Control modal.** La solución cerrada y Fourier comprueban la integración
   directa para la misma carga prescrita; no sustituyen la demanda
   interactiva.
8. **Propagación de incertidumbres.** Las realizaciones Monte Carlo producen
   cuantiles puntuales y distribuciones de extremos espaciales.
9. **Identificación de estados gobernantes.** Cada extremo se registra junto
   con su magnitud, signo, posición angular, etapa constructiva y realización.
10. **Contraste con referencias.** La rama escalar de chapa se compara con la
   relación USACE, la formulación Schwartz--Einstein con HP97 y la
   integración directa con Baker. Núñez se evalúa sólo dentro de su dominio de
   túneles excavados.

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

Un gradiente de presión sobre el diámetro produce una resultante global antes
de considerar el apoyo. El procedimiento vigente la completa con una reacción
radial distribuida sobre toda la circunferencia, determinada por equilibrio y
sin asignar una rigidez $k_r$. Esta restricción no representa una ley
constitutiva del contacto. Los estados que requieran peso propio, flotación u
otras reacciones deben definirlos dentro de su propio sistema de cargas.

Las zonas próximas a extremos, transiciones, aberturas, juntas
circunferenciales, cargas que varían longitudinalmente y corrugaciones
helicoidales quedan fuera del modelo plano. Su evaluación requiere una
formulación espacial específica.

# Conclusiones de la formulación

La demanda transversal de cada revestimiento suma la respuesta uniforme de
Schwartz--Einstein, determinada por el estado de campo libre, la rigidez
relativa y la interfaz, y la corrección equilibrada del gradiente geostático.
Para una carga perimetral prescrita y autoequilibrada, las ecuaciones de la
viga curva, la integración directa y Fourier proporcionan un control
matemático independiente.

Para un estado biaxial uniforme, Schwartz--Einstein produce una componente
uniforme y un armónico de orden dos cuyos coeficientes dependen además de
$C^*$, $F^*$ y la interfaz. La proyección completa y la carga exclusivamente
normal producen otras respuestas porque prescriben directamente componentes
del vector de tracción. Que ambas formulaciones utilicen $n=0$ y $n=2$ no
implica que Fourier convierta una en la otra.

La corrugación se incorpora mediante las rigideces circunferenciales
$K_N$ y $K_M$ de una viga curva por unidad de longitud
axial. Esta idealización modifica la compatibilidad del modo uniforme y
conserva como resultados únicamente $N_\theta$, $M_\theta$ y $Q_\theta$; la
evaluación de tensiones en la chapa y de fuerzas en las uniones corresponde a
una etapa posterior.

La demanda calculada permanece condicionada a confirmar la geometría
seccional y caracterizar el relleno, el estado hidráulico y la secuencia de
compactación. Esas verificaciones actualizan las entradas; no se sustituyen por
un coeficiente oculto de reducción con la profundidad.
