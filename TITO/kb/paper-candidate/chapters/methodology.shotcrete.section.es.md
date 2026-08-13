# Comprobación seccional del hormigón proyectado

## Resultantes y franja de cálculo

Las acciones de entrada son las resultantes circunferenciales por unidad de
longitud del eje:

$$
N_\theta(\theta),\qquad M_\theta(\theta),\qquad Q_\theta(\theta).
$$

Las resultantes conservan la convención general de esta metodología:
$N_\theta>0$ a tracción, $M_\theta>0$ cuando produce tracción en la cara
interior y $Q_\theta>0$ hacia el centro sobre la cara positiva. Para la
comprobación del hormigón se adopta $P_u>0$ en compresión y $M_u>0$ cuando
comprime la cara exterior. El signo de $V_u$ se conserva, aunque la comparación
resistente emplea su valor absoluto. La correspondencia se comprueba mediante
estados de carga de signo conocido.

Las rigideces axial y flexional utilizadas para obtener las resultantes deben
corresponder al revestimiento y al estado analizado. La adopción de propiedades
brutas, reducidas o dependientes de la fisuración constituye una hipótesis del
modelo estructural que debe declararse y comprobarse; no se reutilizan sin
justificación las rigideces ni las resultantes de una sección metálica.

Para una franja longitudinal de ancho $b$:

$$
P_u=-N_\theta b,\qquad M_u=M_\theta b,\qquad V_u=Q_\theta b.
$$ {#eq-shotcrete-strip-resultants}

El cálculo se efectúa en N--mm--MPa. Si $N_\theta$ y $Q_\theta$ se expresan en
kN/m, $M_\theta$ en kN·m/m y $b$ en m:

$$
P_u[\mathrm N]=-10^3N_\theta b,\qquad
V_u[\mathrm N]=10^3Q_\theta b,\qquad
M_u[\mathrm{N\,mm}]=10^6M_\theta b.
$$ {#eq-shotcrete-unit-conversion}

El ancho $b=1.000$ m sólo se adopta cuando la representación mediante franja
unitaria sea compatible con la tipología y con los artículos aplicables. La
selección de $b_w$, $d$ y de la longitud no arriostrada $\ell_c$ se documenta
independientemente; no se igualan de forma automática a $b$, al espesor o a una
longitud geométrica aparente.

## Propiedades resistentes

Para una franja rectangular se definen el espesor resistente efectivo $h$, el
área bruta $A_g=bh$ y el módulo resistente elástico $S_m$ correspondiente a la
cara comprobada. Una sección no rectangular o con pérdida material localizada
requiere calcular $A_g$, el centroide y los módulos resistentes a partir de la
geometría efectiva.

La armadura se representa por capas. Cada capa $j$ debe disponer de área neta
$A_{s,j}$, coordenada $y_j$, tensión de fluencia $f_y$ y módulo $E_s$. Una
cuantía total sin posiciones no define el brazo mecánico ni permite construir
el dominio de flexocompresión.

## Hormigón simple

El capítulo 14 de CIRSOC 201-25 contempla arcos y estructuras subterráneas,
pero limita el hormigón simple estructural a tipologías y condiciones
específicas. Deben comprobarse, entre otros aspectos, el apoyo continuo, el
predominio de compresión por efecto de arco, las juntas y las deformaciones
impuestas [@CIRSOC20125, arts. 14.1--14.4].

Para cada cara, la resistencia nominal a flexión se obtiene mediante

$$
M_{n,t}=0.42\lambda_{\mathrm{lw}}\sqrt{f'_c}\,S_m,
\qquad
M_{n,c}=0.85f'_cS_m,
$$

$$
M_n=\min\left(M_{n,t},M_{n,c}\right),
$$ {#eq-shotcrete-plain-bending}

donde $f'_c$ representa $f'_{c,\mathrm{eq}}$ en una estructura existente y
$\lambda_{\mathrm{lw}}$ es el factor correspondiente al hormigón liviano. La
resistencia nominal a compresión axial es

$$
P_n=0.60f'_cA_g
\left[1-\left(\frac{\ell_c}{32h}\right)^2\right].
$$ {#eq-shotcrete-plain-axial}

La definición reglamentaria de $\ell_c$ para el revestimiento debe quedar
resuelta antes de emplear esta ecuación. Un término entre corchetes no positivo
queda fuera del dominio de aplicación.

Para flexión y compresión combinadas se comprueban simultáneamente la cara
traccionada y la cara comprimida:

$$
\frac{|M_u|}{S_m}-\frac{P_u}{A_g}
\le
\phi\,0.42\lambda_{\mathrm{lw}}\sqrt{f'_c},
$$

$$
\frac{|M_u|}{\phi M_{n,c}}+
\frac{P_u}{\phi P_n}
\le1.0,
\qquad \phi=0.60.
$$ {#eq-shotcrete-plain-interaction}

En una sección asimétrica se repite el cálculo para ambos signos de momento y
con el módulo resistente de cada cara. La formulación anterior no proporciona
una resistencia para tracción axial pura; un estado con $P_u<0$ requiere otra
base resistente.

La resistencia nominal a corte en una dirección es

$$
V_n=0.11\lambda_{\mathrm{lw}}\sqrt{f'_c}\,b_wh,
\qquad |V_u|\le0.60V_n.
$$ {#eq-shotcrete-plain-shear}

Las ecuaciones de esta sección reproducen las expresiones operativas de los
artículos 14.5.2.1, 14.5.3.1, 14.5.4.1 y 14.5.5.1 de CIRSOC 201-25
[@CIRSOC20125]. Su empleo depende de que la sección haya sido clasificada como
hormigón simple y de que el Reglamento resulte aplicable al revestimiento.

## Hormigón armado

### Compatibilidad y equilibrio

La resistencia a flexocompresión se determina mediante equilibrio seccional,
distribución lineal de deformaciones, deformación máxima del hormigón igual a
$0.003$ y resistencia a tracción del hormigón despreciada. Para una profundidad
del eje neutro $c$, medida desde la fibra extrema comprimida:

$$
\varepsilon_s(x)=0.003\left(1-\frac{x}{c}\right),
\qquad
\sigma_s=
\begin{cases}
-f_y, & E_s\varepsilon_s<-f_y,\\
E_s\varepsilon_s, & -f_y\le E_s\varepsilon_s\le f_y,\\
f_y, & E_s\varepsilon_s>f_y.
\end{cases}
$$ {#eq-shotcrete-steel-law}

Con esta convención, las deformaciones de compresión son positivas y las de
tracción son negativas. Para aplicar la Tabla 21.2.2 se identifica la capa
longitudinal más traccionada,

$$
\varepsilon_{s,t}=\min_j\left(\varepsilon_{s,j}\right),
\qquad
\varepsilon_t=\max\left(0,-\varepsilon_{s,t}\right),
$$ {#eq-shotcrete-net-tensile-strain}

de modo que $\varepsilon_t$ es la magnitud positiva de la deformación neta de
tracción y no la deformación firmada de la capa.

El bloque rectangular equivalente tiene intensidad $0.85f'_c$ y profundidad
$a=\beta_1c$, con

$$
\beta_1=
\begin{cases}
0.85, & 20\le f'_c\le28\ \mathrm{MPa},\\[1mm]
0.85-0.05\dfrac{f'_c-28}{7}, & 28<f'_c<55\ \mathrm{MPa},\\[3mm]
0.65, & f'_c\ge55\ \mathrm{MPa}.
\end{cases}
$$ {#eq-shotcrete-beta-one}

Respecto de un origen seccional $y_0$, cada estado nominal satisface

$$
P_n=\int_{A_c}\sigma_c\,\mathrm dA+
\sum_jA_{s,j}\sigma_{s,j},
$$

$$
M_n=\int_{A_c}\sigma_c(y-y_0)\,\mathrm dA+
\sum_jA_{s,j}\sigma_{s,j}(y_j-y_0).
$$ {#eq-shotcrete-reinforced-equilibrium}

El área de hormigón integrada excluye el área ocupada por las barras. El
contorno completo se obtiene variando $c$, incorporando los extremos axiales y
repitiendo el recorrido para cada cara comprimida. La compresión pura
proporciona el control cerrado

$$
P_o=0.85f'_c(A_g-A_{st})+f_yA_{st},
\qquad A_{st}=\sum_jA_{s,j}.
$$ {#eq-shotcrete-pure-compression}

Estas relaciones materializan las condiciones de los artículos 22.2 y
22.4.2.2 [@CIRSOC20125]. El límite $P_{n,\max}$ depende de la clasificación y
del detalle de la armadura transversal; no se asigna hasta establecer esas
condiciones.

### Resistencia de cálculo

El factor de reducción se aplica a cada estado del contorno. Para armadura
transversal distinta de un zuncho en espiral reglamentario:

$$
\varepsilon_{ty}=\frac{f_y}{E_s},
$$

$$
\phi(\varepsilon_t)=
\begin{cases}
0.65, & \varepsilon_t\le\varepsilon_{ty},\\[1mm]
0.65+0.25\dfrac{\varepsilon_t-\varepsilon_{ty}}{0.003},
& \varepsilon_{ty}<\varepsilon_t<\varepsilon_{ty}+0.003,\\[3mm]
0.90, & \varepsilon_t\ge\varepsilon_{ty}+0.003.
\end{cases}
$$ {#eq-shotcrete-phi-flexure}

El dominio de resistencia de cálculo se forma punto a punto:

$$
(P_d,M_d)=\left(\phi P_n,\phi M_n\right).
$$ {#eq-shotcrete-design-domain}

No se aplica un único valor de $\phi$ a todo el dominio. Los factores
incrementados previstos para determinadas evaluaciones de estructuras
existentes sólo se emplean cuando se satisfacen y documentan las condiciones
del capítulo 27 [@CIRSOC20125, tabla 21.2.2 y cap. 27].

### Corte

Cuando la clasificación estructural permita aplicar el modelo de corte en una
dirección, la resistencia nominal es

$$
V_n=V_c+V_s.
$$

Se define primero el valor de la raíz de la resistencia que interviene en
$V_c$:

$$
\chi_c=\min\left(\sqrt{f'_c},8.3\ \mathrm{MPa}\right).
$$ {#eq-shotcrete-shear-strength-limit}

CIRSOC 201-25 permite superar $8.3$ MPa únicamente para vigas y viguetas de
hormigón armado o pretensado que satisfagan la armadura mínima de alma
especificada. Esa excepción sólo se aplica después de documentar la
clasificación y el cumplimiento de los artículos 22.5.3.1 y 22.5.3.2; en los
demás casos se utiliza $\chi_c$.

El aporte axial incorporado en las expresiones de $V_c$ se limita mediante

$$
\zeta_N=\min\left(\frac{P_u}{6A_g},0.05f'_c\right).
$$

Cuando $A_v<A_{v,\min}$, la expresión de la Tabla 22.5.5.1 es

$$
\widehat V_c=
\left[
0.66\lambda_s\lambda_{\mathrm{lw}}\rho_w^{1/3}\chi_c
+\zeta_N
\right]b_wd.
$$ {#eq-shotcrete-shear-below-minimum}

Cuando $A_v\ge A_{v,\min}$, el Reglamento permite seleccionar una de las dos
expresiones siguientes:

$$
\widehat V_{c,a}=
\left[0.17\lambda_{\mathrm{lw}}\chi_c+\zeta_N\right]b_wd,
$$

$$
\widehat V_{c,b}=
\left[
0.66\lambda_{\mathrm{lw}}\rho_w^{1/3}\chi_c+\zeta_N
\right]b_wd.
$$ {#eq-shotcrete-shear-at-minimum}

La expresión seleccionada se fija para la comprobación y se registra con sus
datos. En lo que sigue, $\widehat V_c$ representa
@eq-shotcrete-shear-below-minimum cuando $A_v<A_{v,\min}$, o la expresión
$\widehat V_{c,a}$ o $\widehat V_{c,b}$ seleccionada en
@eq-shotcrete-shear-at-minimum cuando $A_v\ge A_{v,\min}$. En todos los casos:

$$
V_c=
\min\left[
\max\left(\widehat V_c,0\right),
0.42\lambda_{\mathrm{lw}}\chi_c\,b_wd
\right],
$$

$$
\rho_w=\frac{A_s}{b_wd},
\qquad
\lambda_s=\sqrt{\frac{2}{1+0.004d}}\le1.0,
$$ {#eq-shotcrete-reinforced-shear}

$A_s$ es la suma de las áreas de las capas longitudinales ubicadas a más de
dos tercios de la altura total desde la fibra extrema comprimida, para la
dirección y el signo de momento comprobados. El cálculo identifica
expresamente las capas incluidas. Si existe armadura transversal que satisface
las disposiciones aplicables, para estribos perpendiculares

$$
V_s=\frac{A_vf_{yt}d}{s}.
$$

Además de $V_n=V_c+V_s$, el artículo 22.5.1.2 impone un límite asociado a la
compresión diagonal. La resistencia de cálculo a corte queda definida por

$$
V_d=\phi\min\left[
V_c+V_s,
V_c+0.66\sqrt{f'_c}\,b_wd
\right],
\qquad \phi=0.75,
$$

$$
|V_u|\le V_d.
$$ {#eq-shotcrete-reinforced-shear-check}

La aplicación de este modelo a una franja curva debe justificarse mediante la
clasificación del elemento y los artículos 11.5.5.1 y 22.5 de CIRSOC 201-25
[@CIRSOC20125].

## Utilización y reserva resistente

Sea $\mathcal D_d$ el dominio de resistencia de cálculo en el plano $P$--$M$.
Para una demanda no nula se define el multiplicador proporcional

$$
\Lambda_{NM}=\sup\left\{\lambda\ge0:
(\lambda P_u,\lambda M_u)\in\mathcal D_d\right\},
\qquad
\eta_{NM}=\frac{1}{\Lambda_{NM}}.
$$ {#eq-shotcrete-pm-reserve}

La sección satisface la comprobación de flexocompresión cuando
$\Lambda_{NM}\ge1$, equivalente a $\eta_{NM}\le1$. La intersección se obtiene
contra el contorno de cálculo y no mediante cocientes independientes de fuerza
axial y momento.

Para hormigón simple se adopta $V_d=0.60V_n$. Para hormigón armado, $V_d$ es
la menor resistencia de cálculo definida en
@eq-shotcrete-reinforced-shear-check. Cuando $V_c$ depende de $P_u$, el
multiplicador proporcional de corte se define escalando ambas acciones:

$$
\Lambda_V=\sup\left\{\lambda\ge0:
|\lambda V_u|\le V_d(\lambda P_u)\right\}.
$$ {#eq-shotcrete-shear-reserve}

El multiplicador gobernante es

$$
\Lambda_*=\min\left(\Lambda_{NM},\Lambda_V\right).
$$ {#eq-shotcrete-governing-reserve}

$\Lambda_*$ es una reserva frente a una trayectoria proporcional de acciones;
no constituye un factor normativo adicional ni reemplaza los factores de carga
y de reducción de resistencia.

## Comprobaciones de servicio

La resistencia última se complementa con verificaciones independientes de
fisuración, separación y distribución de armaduras, contracción, temperatura,
fluencia lenta, deformaciones, estanqueidad, juntas, recubrimiento y
durabilidad. Estas comprobaciones requieren combinaciones no mayoradas y
criterios de desempeño específicos. No se deducen de $\Lambda_*$ ni se
resuelven con las acciones de resistencia última.

## Productos del cálculo

Para cada ángulo y combinación se conservan, como mínimo:

- $P_u$, $M_u$ y $V_u$, con su conversión de unidades;
- clasificación reglamentaria y propiedades efectivas de la sección;
- dominio nominal y dominio de cálculo $P$--$M$;
- punto resistente correspondiente a la trayectoria de demanda;
- $\Lambda_{NM}$, $\eta_{NM}$, $\Lambda_V$ y $\Lambda_*$;
- resistencia y utilización de corte;
- modo y posición angular gobernantes; y
- comprobaciones no ejecutadas por falta de datos o por quedar fuera del
  alcance seccional.

Los máximos a lo largo de la circunferencia se determinan por combinación y
estado límite. Las envolventes probabilísticas sólo se calculan después de
definir las variables primitivas, sus distribuciones marginales y sus
dependencias; no se asignan distribuciones por defecto.
