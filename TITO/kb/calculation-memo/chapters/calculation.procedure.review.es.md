## Procedimiento de cálculo {#sec-calculation-procedure}

Para cada revestimiento, la demanda resistente se obtiene con la siguiente
secuencia:

1. calcular $z_{ref}$, el estado efectivo de campo libre
   $(\sigma'_{v,ref},\sigma'_{h,ref})$ y los gradientes
   $(\gamma_v,\gamma_h)$;
2. definir el radio, $E_\ell$, $\nu_\ell$, $A_\ell$ e $I_\ell$ propios de la
   sección;
3. calcular las razones de rigidez $C^*$ y $F^*$;
4. resolver el campo uniforme con Schwartz--Einstein para deslizamiento libre
   y sin deslizamiento;
5. proyectar el gradiente lineal en los modos $n=1,3$, incorporar la reacción
   radial $n=1$ y comprobar el equilibrio global;
6. superponer ambas respuestas y obtener $N_\theta(\theta)$,
   $M_\theta(\theta)$ y $Q_\theta(\theta)$ en 720 posiciones del perímetro;
7. repetir los pasos anteriores para cada combinación resistente que modifica
   las componentes vertical y horizontal del campo libre;
8. aplicar las comprobaciones de la chapa, del hormigón simple o de los
   dominios $P$--$M$, según corresponda.

Los extremos espaciales no se mayoran después de obtenidos ni se combinan
entre posiciones distintas. Cada comprobación utiliza las tres resultantes
concurrentes en una misma posición y para una misma combinación.

En paralelo se ejecuta un control mecánico independiente. La carga biaxial
prescrita de la @eq-calculation-biaxial-load se integra mediante el sistema

$$
\frac{d}{d\theta}
\begin{bmatrix}N_\theta\\Q_\theta\\M_\theta\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix},
$$ {#eq-calculation-first-order-system}

con Runge--Kutta de cuarto orden y cierre periódico por compatibilidad. Los
8192 incrementos configurados pertenecen a esta integración numérica; no son
términos de Fourier. Para el estado biaxial uniforme, la carga contiene
exactamente el modo uniforme $n=0$ y el modo de ovalización $n=2$. Por ello,
la representación de Fourier es exacta con esos dos modos y no necesita una
serie de miles de términos. La solución cerrada, Fourier y RK4 resuelven la
misma carga prescrita y deben coincidir dentro de las tolerancias indicadas en
la @tbl-calculation-controls.

{{< include /_tbl/Calculation.controls.ES.qmd >}}

Para controlar la transferencia de Schwartz--Einstein, sus resultantes
$n=0,2$ se reconstruyen como tracciones equivalentes y se resuelven también
con Fourier e integración directa. Esta coincidencia no significa que Fourier
aporte la interacción: $C^*$, $F^*$ y la condición de interfaz ya fueron
calculados por Schwartz--Einstein.

La corrección de gradiente contiene exactamente $n=1,3$. Una reacción radial
$n=1$ equilibra la resultante vertical; luego Fourier y la integración RK4
reproducen las mismas $\Delta N_\theta$, $\Delta M_\theta$ y
$\Delta Q_\theta$. No se utilizan 8192 términos de Fourier: 8192 es el número
de incrementos de la integración numérica independiente.

La formulación de Schwartz--Einstein se contrasta con el ejemplo HP97
publicado para las dos secuencias de carga y las dos condiciones de interfaz
[@SchwartzEinstein1980]. La integración directa se contrasta con los casos de
carga radial por sectores de Baker [@Baker1968]. Los resultados de esos
contrastes se resumen en el apéndice de controles y en la metodología
ampliada.

Las expresiones AASHTO/USACE se aplican por separado al liner corrugado. FHWA
se conserva para una eventual acción constructiva de compactación cuando se
disponga de equipo, tongadas y retención; no introduce un factor permanente en
el caso vigente. Las formulaciones de Núñez se utilizan como antecedentes de
comparación dentro de su dominio y no como una demanda adicional combinada con
Schwartz--Einstein.
