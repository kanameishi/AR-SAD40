# Objeto y alcance de la metodología integrada

## Finalidad

Esta metodología reúne en un único procedimiento las acciones del relleno, la
respuesta de la sección transversal y las comprobaciones estructurales de tres
alternativas: chapa de acero corrugada, hormigón proyectado simple y hormigón
proyectado armado. La memoria de cálculo aplica ese procedimiento a un
escenario determinado; no constituye una segunda metodología.

El estado efectivo inicial se obtiene a partir de la tapada, el peso unitario,
la sobrecarga, el ángulo de fricción efectiva, la historia tensional y la
presión de agua. En el escenario normalmente consolidado, $K_0$ se calcula a
partir de $\phi'$; no se fija como una constante independiente del relleno. Las
tensiones vertical y horizontal se proyectan sobre el contorno circular con
dos prescripciones explícitas: proyección tangencial completa
($\alpha=1$) y acción exclusivamente normal ($\alpha=0$).

Las resultantes $N_\theta(\theta)$, $M_\theta(\theta)$ y
$Q_\theta(\theta)$ se obtienen mediante integración directa de las ecuaciones
de equilibrio de la viga curva y cierre por compatibilidad. La solución
cerrada del estado biaxial uniforme y la representación mediante series de
Fourier son controles matemáticos de esa integración. La formulación de
Schwartz--Einstein se conserva como comparación independiente de interacción
suelo--revestimiento y no genera las demandas de las comprobaciones vigentes.

Cada alternativa utiliza sus propias rigideces circunferenciales. Las
resultantes de la chapa no se transfieren al hormigón simple ni al hormigón
armado. El problema es plano, sin variación longitudinal de las cargas, y las
magnitudes se expresan por unidad de longitud del eje.

## Secuencia de cálculo

El procedimiento comprende las operaciones siguientes:

1. definir la geometría, la tapada, las propiedades del relleno, la condición
   hidráulica y la sección de cada alternativa;
2. derivar $K_0$ de las variables geotécnicas y calcular el estado efectivo en
   la cota de referencia;
3. proyectar ese estado sobre el contorno para $\alpha=1$ y $\alpha=0$;
4. integrar directamente el equilibrio circunferencial e imponer
   compatibilidad para obtener $N_\theta$, $M_\theta$ y $Q_\theta$;
5. contrastar la solución con el caso cerrado y con la representación de
   Fourier sin sustituir la respuesta de producción;
6. repetir la respuesta con las rigideces propias de la chapa, del hormigón
   simple y del hormigón armado;
7. evaluar la chapa mediante la rama de referencia AASHTO aplicable a
   conductos corrugados, manteniendo separados pared, pandeo, costura,
   flexibilidad y tapada mínima; y
8. evaluar el hormigón simple y armado mediante las comprobaciones seccionales
   ACI adoptadas, incluida la familia de dominios $P$--$M$ para distintas
   cuantías de armadura.

La comparación de armaduras es discreta. Cada curva $P$--$M$ representa los
estados resistentes de una cuantía determinada; sus puntos no son iteraciones
del cálculo. Las demandas se mantienen fijas mientras se comparan las curvas,
de modo que el usuario puede adoptar otra malla, reevaluar el caso y revisar
su posición respecto de los dominios.

## Bases resistentes y límites

La clasificación del producto precede a la comprobación de la chapa. La rama
de cálculo reproduce relaciones identificadas para AASHTO LRFD, sección 12.7,
y conserva por separado el estado de verificación de la edición, las erratas y
la aplicabilidad del producto. Mientras esos tres elementos no estén
confirmados para la edición contractual, los resultados son comparaciones
aritméticas de una base de referencia y no una declaración de cumplimiento.
AISI se conserva como antecedente de investigación y no participa del dictamen
vigente.

Para el hormigón proyectado, ACI CODE-318-25 proporciona la comprobación local
implementada de flexocompresión y corte; ACI 318.2-14 se utiliza únicamente
como antecedente explícito para la armadura mínima y la disposición igual en
ambas caras mientras se completa la correspondencia con ACI CODE-318.2-25.
Una comprobación local satisfactoria no resuelve por sí sola fisuración,
servicio, durabilidad, juntas, anclajes, transferencia con la chapa ni
estabilidad global.

La metodología determinística no asigna distribuciones probabilísticas. La
incertidumbre puede propagarse mediante Monte Carlo después de definir y
aprobar las variables primitivas, sus distribuciones marginales y sus
dependencias. Hasta entonces, los estados de proyección, las propiedades y las
alternativas se informan como escenarios separados.
