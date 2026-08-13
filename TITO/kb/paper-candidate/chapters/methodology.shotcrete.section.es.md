# Comprobación seccional de fuerza normal y momento

## Interfaz de demanda

La comprobación resistente recibe, para cada sección y combinación, la fuerza
normal circunferencial y el momento flector por unidad de longitud del eje. Se
adopta $N_\theta>0$ a tracción y $M_\theta>0$ cuando produce tracción en la
cara interior. Para una franja longitudinal de ancho $b$, la convención de la
sección de hormigón es $P_u>0$ en compresión y $M_u>0$ cuando comprime la cara
exterior:

$$
P_u=-N_\theta b,
\qquad
M_u=M_\theta b.
$$ {#eq-shotcrete-strip-resultants}

Si $N_\theta$ se expresa en kN/m, $M_\theta$ en kN·m/m y $b$ en m:

$$
P_u[\mathrm N]=-10^3N_\theta b,
\qquad
M_u[\mathrm{N\,mm}]=10^6M_\theta b.
$$ {#eq-shotcrete-unit-conversion}

La entrada debe identificar sección, combinación, etapa, unidades, base
longitudinal y condición factorizada. La función resistente no aplica de nuevo
los factores de carga. El ancho $b=1.000$ m sólo se adopta cuando la
idealización mediante una franja sea compatible con la clasificación
estructural y con los artículos ACI aplicables.

## Datos de la sección

La geometría se define en milímetros mediante el contorno resistente efectivo,
su eje de referencia y las caras interior y exterior. Cada capa de armadura
$j$ se caracteriza mediante área neta $A_{s,j}$, coordenada $y_j$, módulo
$E_s$, tensión de fluencia y estado de conservación. Las propiedades del
hormigón y del acero son valores de diseño aprobados para la evaluación; no se
infieren dentro del cálculo seccional.

La comprobación rechaza una cuantía total sin posiciones de las capas. También
rechaza una sección sin armadura cuando no se haya documentado la disposición
ACI que habilita esa condición para la tipología seleccionada.

## Compatibilidad y equilibrio

El núcleo mecánico admite una distribución plana de deformaciones:

$$
\varepsilon(y)=\varepsilon_0+\kappa(y-y_0),
$$ {#eq-shotcrete-strain-field}

donde $\varepsilon_0$ y $\kappa$ describen el estado de deformación y $y_0$ es
el origen seccional. Para las leyes constitutivas $\sigma_c(\varepsilon)$ y
$\sigma_s(\varepsilon)$ correspondientes a la norma adoptada, las resultantes
nominales son

$$
P_n=
\int_{A_c}\sigma_c[\varepsilon(y)]\,\mathrm dA
+\sum_jA_{s,j}\sigma_s[\varepsilon(y_j)],
$$

$$
M_n=
\int_{A_c}\sigma_c[\varepsilon(y)](y-y_0)\,\mathrm dA
+\sum_jA_{s,j}\sigma_s[\varepsilon(y_j)](y_j-y_0).
$$ {#eq-shotcrete-reinforced-equilibrium}

Estas relaciones expresan compatibilidad y equilibrio; no son una
transcripción de ACI. Las leyes constitutivas, las deformaciones límite, el
tratamiento del área desplazada por armaduras, los límites axiales y los
factores de reducción se toman del articulado vigente de ACI CODE-318.2-25 y
ACI CODE-318-25. Mientras ese articulado no esté disponible, esos parámetros
permanecen sin definir y el dominio no se calcula.

El contorno nominal se obtiene recorriendo los estados de deformación
admisibles para ambas caras comprimidas e incorporando los extremos axiales.
El contorno de resistencia de cálculo se construye aplicando a cada estado los
factores y límites que le correspondan:

$$
(P_d,M_d)=\mathcal R_{\mathrm{ACI}}(P_n,M_n,\boldsymbol\varepsilon),
$$ {#eq-shotcrete-design-domain}

donde $\mathcal R_{\mathrm{ACI}}$ representa las disposiciones verificadas de
la edición adoptada. No se asigna un factor único a todo el dominio salvo que
el artículo aplicable lo establezca expresamente.

## Decisión resistente

Sea $\mathcal D_d$ el dominio de resistencia de cálculo. La comprobación
normativa primaria consiste en determinar si

$$
(P_u,M_u)\in\mathcal D_d.
$$ {#eq-shotcrete-pm-check}

Como diagnóstico adicional puede calcularse el multiplicador proporcional

$$
\Lambda_{NM}=\sup\left\{\lambda\ge0:
(\lambda P_u,\lambda M_u)\in\mathcal D_d\right\},
\qquad
\eta_{NM}=\frac{1}{\Lambda_{NM}}.
$$ {#eq-shotcrete-pm-reserve}

$\Lambda_{NM}$ describe la reserva sobre una trayectoria proporcional y
$\eta_{NM}$ una utilización geométrica. No son factores adicionales de ACI ni
reemplazan los factores de carga y de resistencia.

## Verificaciones separadas

La fuerza cortante $Q_\theta$ se conserva como resultante y se transforma a la
demanda de la franja sólo cuando se habilite una comprobación de corte
compatible con la clasificación ACI. No se incorpora al dominio $P$--$M$ ni se
convierte mediante una tensión promedio genérica.

La estabilidad de la cáscara, los efectos de segundo orden, la armadura mínima,
el detallado, el servicio, la durabilidad y la ejecución del shotcrete son
puertas independientes. Un punto que satisface el dominio seccional no permite
declarar cumplimiento integral cuando alguna de esas verificaciones permanece
sin evaluar.

## Salidas mínimas

Para cada sección y combinación se conservan:

- demanda $P_u$--$M_u$ y convención de signos;
- geometría, materiales y capas utilizadas;
- dominio nominal y dominio de resistencia de cálculo;
- estado `cumple`, `no cumple`, `no aplicable` o `sin evaluar`;
- estado de deformación y artículo que gobiernan;
- $\Lambda_{NM}$ y $\eta_{NM}$, identificados como resultados derivados;
- residuo de equilibrio y tolerancia numérica; y
- lista de verificaciones separadas y datos pendientes.

La presente versión no produce esas salidas numéricas: faltan la clasificación
estructural, el articulado ACI vigente y los datos resistentes del caso.
