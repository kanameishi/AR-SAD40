# Correspondencia interna de ecuaciones

Esta tabla documenta la correspondencia entre las etiquetas de la memoria de
cálculo y las etiquetas de la metodología integrada vigente. Es un registro
editorial interno y no se incorpora al documento público. La correspondencia
no implica identidad automática de convenciones.

La metodología define la coordenada seccional $z$ positiva hacia el exterior y
declara positivo el momento que tracciona la fibra exterior. Sin embargo, su
ecuación de equilibrio $dM_\theta/d\theta=RQ_\theta$, combinada con
$Q_\theta>0$ hacia el centro sobre la cara positiva, corresponde al momento
positivo que tracciona la fibra interior. La memoria elimina esa ambigüedad:
adopta $\xi=-z$ y define

$$
M_\theta^{\mathrm{calc}}
=\frac{1}{b}\int_{A_b}\sigma_\theta\xi\,dA
=-\frac{1}{b}\int_{A_b}\sigma_\theta z\,dA.
$$

Por lo tanto, respecto de la definición seccional escrita en la metodología,
$M_\theta^{\mathrm{calc}}=-M_\theta^{\mathrm{met,def}}$. Respecto del símbolo
empleado en sus ecuaciones de equilibrio y compatibilidad,
$M_\theta^{\mathrm{calc}}=M_\theta^{\mathrm{met,alg}}$. Las correspondencias de
la tabla para $M_\theta$ se entienden con esta transformación; $N_\theta$ y
$Q_\theta$ conservan sus signos.

| Fórmula de la memoria | Correspondencia en la metodología vigente |
|---|---|
| `eq-calculation-standard-thrust` | sin etiqueta operativa equivalente; USACE EM 1110-2-2902, ec. 4-20; correspondencia con AASHTO 10.ª edición pendiente de comprobar |
| `eq-calculation-depth`, `eq-calculation-vertical-stress` | `eq-depth-theta`, `eq-effective-vertical`, `eq-pore-pressure` |
| `eq-calculation-k0` | `eq-k0-definition` |
| `eq-calculation-k0-reference` | `eq-k0-elastic`, `eq-k0-jaky`; FHWA NHI-05-037, ecs. 5.37--5.38 |
| `eq-calculation-k0-unloading` | Mayne--Kulhawy (1982), ec. 10; desarrollo académico de $K_0$ |
| `eq-calculation-k0-reloading` | Mayne--Kulhawy (1982), ec. 18; desarrollo académico de $K_0$ |
| `eq-calculation-k0-passive-limit` | Mayne--Kulhawy (1982), ecs. 11--12; desarrollo académico de $K_0$ |
| `eq-calculation-stress-projection`, `eq-calculation-biaxial-load` | `eq-mean-difference`, `eq-normal-pressure`, `eq-tangential-traction` |
| `eq-calculation-tangential-multiplier` | interpola los estados prescritos `eq-normal-pressure` y `eq-tangential-traction`; desarrollo integrado en `TITO/kb/paper-candidate/chapters/methodology.load.interaction.es.md` |
| `eq-calculation-first-order-system` | `eq-ring-equilibrium-m`, `eq-ring-equilibrium-r`, `eq-ring-equilibrium-t` |
| `eq-calculation-compatibility-constants` | `eq-general-resultants`, `eq-compatibility-conditions`, `eq-compatibility-constants` |
| `eq-calculation-section-stiffness` | `eq-sectional-constitutive-law`, `eq-corrugated-rigidities`, `eq-corrugated-ratio` |
| `eq-calculation-shotcrete-stiffness`, `eq-calculation-shotcrete-modulus`, `eq-calculation-shotcrete-rigidities` | geometría de una franja rectangular y relación de ACI 318-25, sección 19.2.2.1(b), para estimar la rigidez bruta de corto plazo de la alternativa autónoma |
| `eq-calculation-shotcrete-actions`, `eq-calculation-shotcrete-local-strength` | transformación concurrente de $N_\theta$, $M_\theta$ y $Q_\theta$ y comprobaciones locales de hormigón simple de ACI 318-25, capítulo 14; desarrollo en `eq-shotcrete-strip-resultants`, `eq-shotcrete-plain-tension-check`, `eq-shotcrete-plain-compression-check` y `eq-shotcrete-plain-shear-check` |
| `eq-calculation-concrete-reinforced-minimum`, `eq-calculation-concrete-reinforced-mesh-area`, `eq-calculation-concrete-reinforced-rigidities`, `eq-calculation-concrete-reinforced-actions`, `eq-calculation-concrete-reinforced-utilization` | cuantía mínima total por dirección de ACI 318.2-14, 6.1.3, malla simétrica declarada, disposición de ambas superficies conforme a 6.1.9 y dominio local $P$--$M$ de ACI 318-25, Tabla 21.2.2 y arts. 21.2.2.3, 22.2.1 y 22.2.2; desarrollo en `eq-shotcrete-reinforced-minimum`, `eq-shotcrete-reinforced-mesh-area`, `eq-shotcrete-reinforced-layer-coordinate`, `eq-shotcrete-reinforced-equilibrium` y `eq-shotcrete-reinforced-radial-utilization` |
| `eq-calculation-biaxial-alpha-response` | superposición lineal de `eq-k0-normal-response` y `eq-k0-full-response` |
| `eq-calculation-aisi-flexural-bound` | antecedente no activo; cota derivada a partir de AISI S100 F1--F4 y de la geometría publicada de la sección |
| `eq-calculation-aashto-seam-utilization-corroded`, `eq-calculation-aashto-seam-diameter`, `eq-calculation-aashto-seam-area-ratio`, `eq-calculation-aashto-seam`, `eq-calculation-aashto-seam-loss-limit` | formulación de sensibilidad derivada para reducir la resistencia publicada de la costura mediante la relación de áreas del perno remanente y nominal; no se atribuye a AASHTO |
| comprobaciones AISI H1 y H2 | antecedentes no activos, excluidos del ensamblado metodológico vigente |

La correspondencia identifica procedencia y equivalencia conceptual. Las
etiquetas públicas se modifican únicamente en la fuente metodológica canónica.
