# Fuentes de carga y adaptadores

## 1. Perfil vertical y ordenadas de control

Sea $H$ la tapada medida desde el terreno hasta la clave y $R$ el radio centroidal. Las profundidades de control son

$$
z_C=H,
\qquad
z_S=H+R,
\qquad
z_I=H+2R,
$$

para clave, eje/springline y solera. Para capas horizontales,

$$
\sigma'_v(z)=q'+\int_0^z\gamma'(\zeta)\,d\zeta,
\qquad
\sigma_v(z)=\sigma'_v(z)+u(z).
$$

El código integra por capas los pesos unitarios efectivos declarados y calcula $u(z)$ por separado. Esto evita sumar dos veces el agua. Antes de generar una carga angular se informan siempre las seis ordenadas

$$
\sigma'_v(z_C),\ \sigma'_v(z_S),\ \sigma'_v(z_I),
\qquad
u(z_C),\ u(z_S),\ u(z_I).
$$

El modelo constante al eje usa $\sigma'_v(z_S)$ y $u(z_S)$. El modelo con gradiente conserva las variaciones sobre el diámetro y puede generar un modo $n=1$; ese modo sólo se resuelve si la carga total tiene resultante global nula.

## 2. Presión en reposo

La relación básica es

$$
\sigma'_h(z)=K_0(z)\sigma'_v(z).
$$

Como relación geotécnica general, USACE EM 1110-2-2902 (2020), Ec. 5-6,
página impresa 140/PDF 154, usa para suelo normalmente consolidado

$$
K_{0,NC}=1-\sin\phi'.
$$

USACE EM 1110-2-2502 (2022), Ecs. 6.9–6.11, página impresa 131, también presenta

$$
K_{0,OC}=(1-\sin\phi')OCR^{\sin\phi'},
\qquad
\sigma'_{h0}=K_0\sigma'_{v0},
$$

y advierte que la compactación y la historia de tensiones pueden elevar $K_0$. Ninguna de esas ecuaciones transforma la energía del equipo de compactación en $OCR$: esa relación permanece `UNKNOWN`.

La Ec. 5-6 de EM 1110-2-2902 aparece en el contexto de fractura hidráulica y
perforación, y EM 1110-2-2502 trata estructuras de retención. Estas citas no
son una prescripción USACE de contacto suelo–CMP. Se usan como modelos
geotécnicos generales y deben contrastarse con la caracterización del relleno.

En el código, $K_0$ por historia tensional y un incremento horizontal residual se mantienen como entradas diferentes:

$$
\sigma'_{h,c}=K_0\sigma'_v+\Delta\sigma'_{h,c}.
$$

No se deben usar simultáneamente un $K_0$ ya calibrado al estado compactado y un $\Delta\sigma'_{h,c}$ que represente la misma historia.

## 3. Del tensor de campo libre al círculo

Para un estado compresivo constante

$$
\boldsymbol\sigma'=
\begin{bmatrix}
\sigma'_h&0\\0&\sigma'_v
\end{bmatrix},
$$

la proyección geométrica sobre el círculo produce

$$
p_n(\theta)=u+\frac{\sigma'_v+\sigma'_h}{2}
+\frac{\sigma'_v-\sigma'_h}{2}\cos2\theta,
$$

$$
p_t(\theta)=\frac{\sigma'_v-\sigma'_h}{2}\sin2\theta.
$$

Esta es una derivación tensorial, no una afirmación de que el contacto final sea idéntico al campo libre. Se calculan dos límites discretos:

- `fullTraction`: transmite las componentes normal y tangencial anteriores;
- `normalOnly`: conserva $p_n$ e impone $p_t=0$.

Si $K_0=1$, ambos se reducen a presión radial uniforme. Si $K_0\ne1$, la diferencia genera un modo ovalizante $n=2$. El agua añade sólo el término normal isotrópico cuando se adopta presión hidrostática a una profundidad de referencia.

## 4. Adaptador USACE 2020 para CMP

USACE EM 1110-2-2902 (2020) gobierna el diseño de CMP por AASHTO LRFD §12.7. El ejemplo D4, página impresa 332/PDF 346, calcula la presión vertical muerta en clave como

$$
P_{FD}=\gamma H.
$$

La Ec. 4-20, página impresa 86/PDF 100, da el empuje factorizado

$$
T_L=
\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2},
$$

donde $S$ es la luz, $P_{FL}$ la presión viva en clave y $C_L,F_1$ provienen de AASHTO. El manual no entrega una distribución angular ni $M,Q$.

La Ec. 4-20 no admite entradas vivas arbitrarias: $C_L\leq S$, $F_1$ debe
cumplir los mínimos remitidos a AASHTO y la carga viva sólo se omite si se
verifican conjuntamente $H>8\ \mathrm{ft}$ y $H>S$. El adaptador exige
confirmar esas verificaciones y registrar la procedencia de $P_{FL}$, $C_L$ y
$F_1$; acepta los tres como positivos o los tres como cero bajo una omisión
documentada.

Para separar física y factores de resistencia se define primero

$$
T_{service}=
\frac{P_{FD}S}{2}
+\frac{P_{FL}C_LF_1}{2}.
$$

Una presión radial uniforme equivalente

$$
p_{eq}=\frac{2T_{service}}{S}
$$

produce, con $R=S/2$,

$$
N_0=-p_{eq}R=-T_{service}.
$$

Esta equivalencia sólo reproduce el empuje escalar. No autoriza a interpretar $M=Q=0$ como predicción USACE del contacto real.
El adaptador conserva $R=S/2$ como radio requerido y el solver rechaza un
radio diferente. Para la presión uniforme equivalente obtiene $M=Q=0$; esos
ceros son consecuencias del surrogate y no resultados publicados por USACE.

### Inconsistencias que el programa no resuelve por conjetura

- Eq. 4-20 y el ejemplo D4 usan $\gamma_{DL}=1.95$, mientras la Tabla 4-4 asigna $1.50$ a presión vertical sobre CMP/FRP.
- Eq. 4-21 usa $\eta_{cmp}=1.05$, mientras D4 usa $1.10$.
- D4 contiene referencias cruzadas incorrectas a ecuaciones y secciones.

Por ello, los factores LRFD son argumentos explícitos y su procedencia se guarda con cada cálculo. No se muestrean como incertidumbres físicas.

## 5. Adaptadores FHWA-RD-98-191

El informe *Pipe Interaction with the Backfill Envelope* es investigación FHWA, no norma o especificación.

### 5.1 Carga global de prisma y VAF

Las Ecs. 2.1–2.3, página impresa 12/PDF 28, definen

$$
W_{sp}=\gamma_sD_o(H+0.11D_o),
$$

$$
W_p=VAF\,W_{sp}=2T_{sl}.
$$

El resultado es una carga global y un empuje de springline. No determina de manera única $p_n(\theta),p_t(\theta)$. La fuente muestra coeficientes Heger/SIDD, pero no reproduce las ecuaciones por tramos ni define matemáticamente todos sus parámetros. El adaptador angular Heger/SIDD permanece bloqueado hasta obtener la fuente primaria.

El $VAF$ es una entrada con procedencia y aplicabilidad obligatorias. Un valor
publicado para otro material o sistema de instalación no se transfiere a acero
sin justificación.

### 5.2 Presión de compactación por etapa

La Ec. 5.1, página impresa 177/PDF 192, es

$$
n_p=1.3P(1-\sin\phi)^3
\left(\frac{970}{d_c-250}\right)^2,
$$

exclusivamente en SI, con:

- $n_p$: presión nodal usada en CANDE, kPa;
- $P$: fuerza total del compactador, kN, no menor que $4\ \mathrm{kN}$;
- $\phi$: ángulo de fricción del suelo suelto, grados;
- $d_c$: diámetro centroidal, mm.

La correlación se calibró con información limitada: dos suelos, diámetros nominales de 900 y 1500 mm, un rammer de 20.5 kN, una placa de 5.2 kN y el pseudo-caso de 4 kN. No define priors ni error probabilístico.

Para reproducir la Tabla 5.5 se usan los diámetros **centroidales** $970$ y
$1\,575\ \mathrm{mm}$. El código distingue entre estar dentro de los rangos
marginales y coincidir con una de las nueve configuraciones publicadas; un
punto intermedio no se rotula como ensayado. La última fila imprime
$\phi=28^\circ$, pero el valor $0.2\ \mathrm{kPa}$ exige $36^\circ$; la
discrepancia se conserva en la tabla de benchmark.

El procedimiento no-FEM conserva la construcción por etapas. Para la superficie de un lift en $z_s$, la presión horizontal actúa en una banda de 300 mm inmediatamente debajo. Con $z$ positivo hacia abajo,

$$
I_s(\theta)=
\begin{cases}
1,&z_s\le -R\cos\theta\le z_s+0.300,\\
0,&\text{fuera de la banda},
\end{cases}
$$

$$
t_x(\theta)=-n_p\operatorname{sgn}(R\sin\theta)I_s(\theta),
\qquad t_z(\theta)=0,
$$

y la transformación a la base del anillo es

$$
P_r=t_x\sin\theta-t_z\cos\theta,
\qquad
P_t=t_x\cos\theta+t_z\sin\theta.
$$

La Ec. 5.1 aporta la amplitud; la banda y la dirección horizontal siguen la
Sección 5.2.1 y la Figura 5.4, páginas impresas 173–175/PDF 188–190. La
conversión continua y su integración por el solver directo están rotuladas
como implementación derivada; el truncamiento modal pertenece sólo al
comparador Fourier.

La carga se resuelve para cada lift y se conservan los máximos durante construcción. FHWA no publica un factor de retención de la presión cuando el compactador se retira. Por tanto, el estado final se calcula sin esa banda o con un factor residual declarado por el analista; este último no se atribuye a FHWA.

![Aplicación numérica de una banda FHWA a un caso publicado de control. La superficie del lift se fija en el eje para verificar la implementación; no es un estado final ni un dato del proyecto.](/TITO/kb/figures/fhwa-compaction-stage.png){#fig-fhwa-stage-response width=100%}

## 6. Adaptador Núñez

Núñez (2000) y Núñez–Sfriso–Laiún (2014) estudian sostenimientos de túneles excavados. La profundidad $H$ de esos documentos se mide hasta el eje, no hasta la clave. El adaptador directo conserva el dominio `excavated_tunnel_shotcrete` y marca `outOfDomainForBackfilledPipe=TRUE`.

La versión 2014 define

$$
P=\gamma H+q
$$

y publica, en su página PDF 6, Ecs. 22–25,

$$
M_{max}=\frac{1}{16}\eta(1-K_0)PD^2\frac{a}{1+a},
$$

$$
N_A=\frac12\eta DP,
$$

$$
N_C=\frac12\eta DP
\left[K_0+\frac23\frac{1-K_0}{1+a}\right]
-\frac1{12}K_0\gamma D^2,
$$

$$
N_I=\frac12\eta DP
\left[K_0+\frac43\frac{1-K_0}{1+a}\right]
+\frac1{12}K_0\gamma D^2.
$$

No publica $Q$ ni funciones angulares completas. El adaptador directo devuelve sólo esos valores. Los $N_C,N_A,N_I$ son magnitudes de compresión positivas en la convención de la fuente; no se combinan con el solver, que usa $N>0$ a tracción, sin una conversión explícita.

### Proyección simétrica controlada

Como comparador se implementó una derivación que conserva la parte simétrica $n=0+n=2$. Se define

$$
V=\eta P,
\qquad
H_e=\eta P\left[K_0+\frac{1-K_0}{1+a}\right],
$$

$$
\Delta=V-H_e
=\eta P(1-K_0)\frac{a}{1+a},
\qquad
p_m=\frac{V+H_e}{2}.
$$

El campo que se proyecta es

$$
P_r=-p_m-\frac{\Delta}{2}\cos2\theta,
\qquad
P_t=+\frac{\Delta}{2}\sin2\theta.
$$

El operador del anillo reproduce exactamente

$$
M(0)=M_{max},
\qquad
|N(\pi/2)|=N_A,
\qquad
|N(0)|=\frac{N_C+N_I}{2}.
$$

No reproduce la diferencia corona–solera. El residuo se informa aparte:

$$
\frac{N_I-N_C}{2}
=\frac{D}{2}\eta P\frac{1}{3}\frac{1-K_0}{1+a}
+\frac{1}{12}K_0\gamma D^2.
$$

Construir un modo impar para ajustar ese residuo exigiría una condición de reacción que Núñez no publica. El $Q(\theta)$ de esta rama es una salida de la proyección derivada, no un valor de Núñez.

### Discrepancias documentales

Las versiones 2000/2014 no se mezclan. Entre otras diferencias verificadas:

- $N_\phi+1$ en 2000 frente a $N_\phi-1$ en 2014 para la corona plástica;
- la Ec. 11 de 2014 omite `/B` respecto de 2000 y queda dimensionalmente incorrecta;
- aparecen factores 6/12 incompatibles y una doble aplicación de factores de Poisson;
- $N_A$ contiene $\eta$ en 2014 pero no en 2000; las expresiones de $N_C$ tampoco son equivalentes;
- $\eta$ no representa el mismo proceso físico en ambos documentos.

El código exige que $a$ o la razón modular lleven una fuente explícita. No selecciona silenciosamente una corrección.
