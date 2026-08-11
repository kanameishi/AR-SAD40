# Resumen {.unnumbered}

Se establece un procedimiento para determinar las resultantes seccionales de
un revestimiento circular enterrado de
chapa de acero corrugada. El cálculo se formula por unidad de longitud axial y
entrega las distribuciones de fuerza normal circunferencial
$N_\theta(\theta)$, momento flector $M_\theta(\theta)$ y fuerza cortante
$Q_\theta(\theta)$. Estas magnitudes constituyen la demanda para la posterior
verificación de la chapa y de las uniones.

La determinación geotécnica de las acciones se mantiene separada de la
respuesta estructural. Las acciones se expresan mediante las componentes
normal y tangencial del vector de tracción sobre el contorno. La respuesta se
obtiene a partir del equilibrio y la compatibilidad de una viga curva circular
cerrada. La formulación comprende distribuciones continuas, cargas por
sectores y estados de compactación cuya extensión angular se encuentre
definida.

Para un estado biaxial uniforme del relleno, la carga contiene un término
uniforme y un término de orden dos asociado al modo de ovalización. La solución
explicita la influencia de la tapada, el coeficiente de presión de tierras en
reposo $K_0$, la diferencia de presión intersticial y la componente tangencial
de la tracción. Las distribuciones generales se resuelven por integración
angular directa; una representación mediante series de Fourier proporciona
una formulación modal alternativa para comprobar la solución e interpretar la
contribución de cada armónico.

La incertidumbre de las propiedades del relleno y de la construcción se
propaga mediante simulación Monte Carlo directa. Cada realización produce las
tres distribuciones y sus extremos espaciales. Las hipótesis de transferencia
de carga y de compactación se evalúan como alternativas separadas mientras no
exista evidencia para asignarles probabilidades.

El ejemplo analítico utiliza parámetros nominales suministrados como base del
estudio y un estado biaxial uniforme a la cota del eje. Las ecuaciones permiten
localizar los extremos de las tres resultantes para ese estado. La
determinación de la demanda del revestimiento existente requiere completar la
caracterización geotécnica y constructiva enumerada en la sección de
aplicación.

# Objeto, alcance y bases de cálculo

## Sistema analizado

El revestimiento se representa mediante su sección transversal circular y las
resultantes se expresan por unidad de longitud medida sobre el eje del
conducto. La geometría, las propiedades seccionales y las acciones se
consideran invariantes en esa dirección. La idealización estructural es una
viga curva circular cerrada, de sección uniforme, comportamiento elástico
lineal y pequeñas deformaciones.

El radio $R$ corresponde al eje centroidal de la sección resistente. La tapada
$H_0$ se mide verticalmente entre la superficie del terreno y la clave. El
ángulo $\theta$ se mide desde la clave y aumenta en sentido horario; por lo
tanto, $\theta=\pi/2$ y $3\pi/2$ corresponden a los hastiales a la altura del
eje, y $\theta=\pi$ corresponde a la solera.

Sean $\mathbf e_r$ la dirección radial hacia el exterior y $\mathbf e_t$ la
dirección tangencial correspondiente al aumento de $\theta$. Las cargas
distribuidas se describen mediante $P_r(\theta)$, positiva según
$\mathbf e_r$, y $P_t(\theta)$, positiva según $\mathbf e_t$. Para una
coordenada seccional $z$ positiva hacia el exterior,

$$
N_\theta=\int_A\sigma_\theta\,dA,
\qquad
M_\theta=\int_A\sigma_\theta z\,dA.
$$ {#eq-resultant-signs}

En consecuencia, $N_\theta>0$ representa tracción y $M_\theta>0$ produce
tracción en la fibra exterior. En la cara positiva de un elemento diferencial,
cuya normal sigue $\mathbf e_t$, $Q_\theta>0$ actúa hacia el centro del
revestimiento. Estas definiciones determinan los signos utilizados en las
ecuaciones de equilibrio.

Cuando $P_r$ y $P_t$ se expresan en kPa y $R$ en m, las unidades de las
resultantes son

$$
[N_\theta]=[Q_\theta]=\mathrm{kN/m},
\qquad
[M_\theta]=\mathrm{kN\,m/m}.
$$

## Alcance de la etapa

El cálculo comprende:

1. la estimación de las tensiones verticales efectivas y totales en el
   relleno;
2. la definición del estado lateral mediante $K_0$ y, cuando corresponda, un
   incremento asociado a la compactación;
3. la transformación del estado tensional en cargas distribuidas sobre el
   contorno;
4. la determinación de $N_\theta(\theta)$, $M_\theta(\theta)$ y
   $Q_\theta(\theta)$;
5. la obtención de extremos y envolventes mediante simulación Monte Carlo.

La evaluación resistente requiere recuperar las tensiones locales de la chapa
corrugada, representar los solapes y establecer la resistencia de las uniones
con pernos. Esas comprobaciones se desarrollan a partir de los estados de
solicitación que gobiernen el revestimiento.
