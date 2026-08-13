# Evaluación elástica de la chapa corrugada deteriorada

## Alcance de la recuperación

Las resultantes $N_\theta$, $M_\theta$ y $Q_\theta$ describen la demanda de una
franja del revestimiento por unidad de longitud del eje. La transformación de
esas magnitudes en tensiones requiere una sección resistente actual y una
hipótesis cinemática compatible con la corrugación y la curvatura del
revestimiento.

La relación desarrollada en este capítulo recupera la tensión normal
circunferencial de una sección homogeneizada en régimen elástico. Constituye
una medida de demanda para interpretar la primera fluencia. La resistencia de
pared, el pandeo, la continuidad de ligamentos, las costuras y los pernos son
estados diferentes y se verifican mediante la rama normativa correspondiente
al producto instalado [@USACE2020, tabla 4-2 y sec. 4.12].

## Representación del deterioro

### Magnitudes de espesor

Se distinguen tres magnitudes:

- $t_{\rm nominal}$: espesor original documentado;
- $t_{\rm measured}(\theta,x_L,s)$: espesor metálico actual observado; y
- $t_{\rm design}(\theta,s)$: espesor adoptado para una verificación después
  de aplicar una regla espacial y, cuando corresponda, una pérdida futura
  explícita.

$x_L$ es la coordenada longitudinal de la inspección y $s$ recorre la línea
media de una celda corrugada. La dependencia longitudinal del campo medido no
introduce una variación longitudinal de las cargas en el modelo mecánico
plano. Describe únicamente la posición de las observaciones utilizadas para
construir una estación de cálculo o una envolvente.

Mai distinguió mediciones disponibles, perforaciones, superficies demasiado
degradadas para obtener una lectura y zonas inaccesibles por obstrucciones. En
los especímenes estudiados asignó espesor efectivo nulo a perforaciones y a
superficies materialmente degradadas que no admitían medición; una zona no
accesible conserva, en cambio, un estado desconocido [@Mai2013, pp. 44--53].
Esos estados se registran por separado porque no tienen el mismo significado
estructural.

La reducción del campo observado se expresa, como definición de esta
metodología, mediante

$$
t_{\rm design}(\theta,s)
=\mathcal R\!\left[
t_{\rm measured}(\theta,x_L,s),
q(\theta,x_L,s),
f_p(\theta,x_L,s)
\right]-c_{\rm future},
$$ {#eq-methodology-thickness-reduction}

donde $q$ identifica el estado de la lectura, $f_p$ es la fracción perforada
y $c_{\rm future}$ es una pérdida posterior a la fecha de inspección. La
operación $\mathcal R$ debe declarar si selecciona una estación, una
envolvente o una agregación sustentada por un mecanismo de reparto. El modelo
plano no justifica por sí mismo un promedio longitudinal. La corrosión
histórica ya contenida en $t_{\rm measured}$ no se descuenta por segunda vez.

Los errores de hasta aproximadamente 3 % para el transductor de dos elementos
y de hasta 6 % para un transductor simple en zonas de picado severo son
resultados de los ensayos de Mai, no límites universales ni distribuciones de
probabilidad transferibles [@Mai2013, pp. 46--48].

### Propiedades netas de la corrugación

Sea $b_{\rm ref}$ el ancho longitudinal proyectado de referencia, $y(s)$ la
coordenada radial de la línea media y $t_{\rm design}(s)$ el espesor de cálculo
en la estación considerada. Para una idealización de pared delgada,

$$
\bar A_n
=\frac{1}{b_{\rm ref}}
\int_{\mathcal C}t_{\rm design}(s)\,ds,
\qquad
\bar y_n
=\frac{
\int_{\mathcal C}y(s)t_{\rm design}(s)\,ds
}{
\int_{\mathcal C}t_{\rm design}(s)\,ds
},
$$

$$
\bar I_n
=\frac{1}{b_{\rm ref}}
\int_{\mathcal C}
\left[y(s)-\bar y_n\right]^2
t_{\rm design}(s)\,ds.
$$ {#eq-methodology-net-section}

$\bar A_n$ se expresa en mm²/mm y $\bar I_n$ en mm⁴/mm. Cuando el espesor no
pueda despreciarse respecto de la curvatura local del perfil, la integración
geométrica debe incluir la inercia propia de cada elemento. Las tablas de
perfiles normalizados constituyen un contraste de geometría y unidades, pero
no sustituyen el levantamiento de la sección actual [@NCSPA2018, tabla 2.6].

Las rigideces circunferenciales netas son

$$
(EA)_n=E_\theta\bar A_n,
\qquad
(EI)_n=E_\theta\bar I_n.
$$

Cuando una representación de pared lisa sea necesaria, el espesor y el módulo
que conservan simultáneamente esas dos rigideces son

$$
\bar t_n=\sqrt{\frac{12\bar I_n}{\bar A_n}},
\qquad
\bar E_n=\frac{E_\theta\bar A_n}{\bar t_n}.
$$ {#eq-methodology-equivalent-section}

Mai empleó esta equivalencia en modelos bidimensionales y mostró que reducir
únicamente el espesor de un sólido equivalente puede conservar una rigidez y
degradar incorrectamente la otra [@Mai2013, pp. 13--16 y 122--123]. El cálculo
de la sección transversal puede operar directamente con $(EA)_n$ y $(EI)_n$;
no necesita introducir $\bar t_n$ y $\bar E_n$ como propiedades adicionales.

## Recuperación de la tensión normal circunferencial

Se adopta $N_\theta>0$ a tracción. La coordenada $y$ se mide desde el
centroide neto y es positiva hacia el exterior. Se toma $M_\theta>0$ cuando
comprime la fibra de coordenada positiva. Bajo la hipótesis de deformaciones
lineales,

$$
\sigma_\theta(\theta,y)
=\frac{N_\theta(\theta)}{\bar A_n}
-1000\,
\frac{M_\theta(\theta)y}{\bar I_n},
$$ {#eq-methodology-sheet-normal-stress}

con $N_\theta$ en kN/m, $M_\theta$ en kN·m/m, $y$ en mm y
$\sigma_\theta$ en MPa. Las componentes son

$$
\sigma_{\theta,N}=\frac{N_\theta}{\bar A_n},
\qquad
\sigma_{\theta,M}=-1000\frac{M_\theta y}{\bar I_n}.
$$

La tensión se evalúa en las fibras extremas exterior e interior, medidas desde
el centroide de la sección neta. Con una coordenada alternativa $\xi=-y$
positiva hacia el interior, la misma ecuación se escribe
$\sigma_\theta=N_\theta/\bar A_n+1000M_\theta\xi/\bar I_n$.

Mai recuperó $N$ y $M$ desde deformaciones de valle y cresta mediante una
distribución lineal y dejó de informar esas resultantes después de la fluencia
[@Mai2013, pp. 73--74 y 81--82]. Ese antecedente respalda el uso de una
recuperación elástica a escala de la corrugación, pero no establece que la
distribución sea exacta para cualquier relación entre profundidad del perfil y
radio del revestimiento.

## Condición de curvatura

En una viga curva, el eje neutro y la distribución de tensiones por flexión no
coinciden en general con la solución lineal de una viga recta. La diferencia
disminuye cuando la dimensión radial de la sección es pequeña respecto del
radio de curvatura [@USBR1968Beggs, p. 6]. La recuperación de la
@eq-methodology-sheet-normal-stress requiere, por lo tanto, uno de los
siguientes respaldos:

1. un criterio geométrico aplicable a la corrugación y al radio considerados;
2. un contraste con una solución de viga curva que cuantifique la diferencia;
   o
3. una formulación de viga curva adoptada directamente.

Mientras ese control no esté resuelto, las propiedades y las resultantes se
conservan, pero la tensión calculada mediante la relación lineal permanece sin
evaluar para el revestimiento existente.

## Primera fluencia y estados resistentes

Si el grado de acero y una condición uniaxial son aplicables, puede definirse
el cociente diagnóstico

$$
r_y
=\frac{
\displaystyle\max_{\theta,\,y\in\{y_o,y_i\}}
|\sigma_\theta(\theta,y)|
}{F_y},
$$ {#eq-methodology-first-yield-ratio}

donde $F_y$ es la tensión de fluencia y $y_o$, $y_i$ son las fibras exterior e
interior. $r_y=1$ representa la primera fluencia dentro de la idealización
elástica. El cociente no es una utilización normativa general ni un factor de
seguridad global: no incluye pandeo, costuras, sección efectiva, perforaciones,
fatiga ni factores de resistencia o carga.

La tensión equivalente requiere que $\sigma_\theta$, la tensión longitudinal
y el corte correspondan al mismo punto y al mismo estado constitutivo. Un
problema de cargas invariantes en la dirección longitudinal no determina por
sí solo si la condición material es de tensión plana o de deformación plana.
Hasta cerrar esa condición no se calcula una tensión equivalente.

## Tratamiento de $Q_\theta$ y de las perforaciones

$Q_\theta$ es una resultante seccional y se conserva en los productos del
cálculo. Su transformación en tensión local exige una distribución de flujo
cortante o un área efectiva compatible con la geometría corrugada. No se
emplea una expresión rectangular genérica para inferir $\tau$.

La presencia de perforaciones o ligamentos aislados abre mecanismos que no
están representados por la tensión normal homogeneizada. En el espécimen CSP1,
Mai observó plastificación localizada y pandeo de ligamentos cerca de la carga
máxima, sin poder separar cuál de ambos mecanismos gobernó la falla
[@Mai2013, pp. 86--90]. Por ello:

- una sección continua y representable puede avanzar a la recuperación
  elástica condicionada;
- una sección perforada puede conservar la tensión global como diagnóstico,
  pero requiere una evaluación adicional de continuidad y estabilidad local;
  y
- una zona inaccesible permanece sin caracterizar hasta obtener evidencia.

## Información requerida para una verificación resistente

La comprobación del revestimiento existente requiere, además de las
resultantes:

1. identificación del producto y orientación de la corrugación;
2. norma, edición y combinaciones de acciones adoptadas;
3. mapa de espesores, estados de lectura, perforaciones y regla de reducción;
4. propiedades netas y coordenadas de las fibras;
5. grado de acero y evidencia de $F_y$, $F_u$ y $E$;
6. criterio de curvatura;
7. condición longitudinal;
8. formulaciones de pandeo y estabilidad local; y
9. geometría y resistencia de costuras y pernos.

La ausencia de cualquiera de los datos que gobiernan un estado límite se
informa como una condición abierta. No se reemplaza por una resistencia
supuestamente conservadora sin una base documentada.

## Variables de incertidumbre

Una futura simulación puede considerar el espesor observado, el error de
medición, la fracción perforada, el estado de lectura, la pérdida futura y la
alternativa de reducción espacial. Mai permite identificar esas variables,
pero sus ensayos no definen las distribuciones marginales ni las dependencias
aplicables al proyecto. Hasta contar con mediciones suficientes se emplean
escenarios determinísticos de espesor y agregación.
