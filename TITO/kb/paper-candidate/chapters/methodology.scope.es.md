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
partir de $\phi'$; no se fija como una constante independiente del relleno. El
estado de campo libre resultante alimenta la solución de carga externa de
Schwartz--Einstein para los límites con deslizamiento libre y sin
deslizamiento.

Las resultantes $N_\theta(\theta)$, $M_\theta(\theta)$ y
$Q_\theta(\theta)$ de diseño suman dos componentes. Schwartz--Einstein
determina los modos uniformes y de ovalización con las rigideces propias de
cada revestimiento; la variación geostática lineal entre clave y solera se
incorpora mediante una corrección equilibrada de modos $n=1,3$. En forma
separada, el estado biaxial uniforme se proyecta como carga prescrita y se
resuelve mediante integración directa de las ecuaciones de la viga curva y
cierre por compatibilidad. La solución cerrada y Fourier controlan esa
integración; no reemplazan la interacción ni convergen a ella.

Cada alternativa utiliza sus propias rigideces circunferenciales. Las
resultantes de la chapa no se transfieren al hormigón simple ni al hormigón
armado. El problema es plano, sin variación longitudinal de las cargas, y las
magnitudes se expresan por unidad de longitud del eje.

En Schwartz--Einstein, $E_g$, $\nu_g$, el radio y las rigideces del anillo
determinan las razones $C^*$ y $F^*$ y redistribuyen la demanda. En el control
de carga prescrita, la rigidez no redistribuye los modos $n\geq2$; la razón
$I/(AR^2)$ sólo interviene en la compatibilidad del momento uniforme. Esta
diferencia mantiene separadas ambas formulaciones.

## Secuencia de cálculo

El procedimiento comprende las operaciones siguientes:

1. definir la geometría, la tapada, las propiedades del relleno, la condición
   hidráulica y la sección de cada alternativa;
2. derivar $K_0$ de las variables geotécnicas y calcular el estado efectivo en
   la cota de referencia;
3. calcular $C^*$ y $F^*$ y resolver la carga externa de
   Schwartz--Einstein para cada revestimiento y cada límite de interfaz;
4. proyectar el gradiente geostático lineal, incorporar la reacción radial
   que equilibra el modo $n=1$ y superponer sus modos $n=1,3$;
5. formar las combinaciones resistentes y recalcular las resultantes
   concurrentes;
6. proyectar por separado el estado biaxial uniforme como carga prescrita, integrarlo y
   controlarlo contra la solución cerrada y Fourier;
7. comprobar que cada alternativa conserva su propio radio y sus propias
   rigideces;
8. evaluar la chapa mediante la rama de referencia AASHTO aplicable a
   conductos corrugados, manteniendo separados pared, pandeo, costura,
   flexibilidad y tapada mínima; y
9. evaluar el hormigón simple y armado mediante las comprobaciones seccionales
   ACI adoptadas, incluida la familia de dominios $P$--$M$ para distintas
   cuantías de armadura.

La comparación de armaduras es discreta. Cada curva $P$--$M$ representa los
estados resistentes de una cuantía determinada; sus puntos no son iteraciones
del cálculo. Las demandas se mantienen fijas mientras se comparan las curvas,
de modo que el usuario puede modificar los parámetros y reevaluar el caso. La
metodología no selecciona una cuantía óptima ni adopta una malla final.

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
dependencias. Hasta entonces, las condiciones de interfaz, las propiedades y
las alternativas se informan como escenarios separados.
