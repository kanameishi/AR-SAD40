# Correspondencia interna de ecuaciones

Esta tabla documenta la correspondencia entre las etiquetas de la memoria de
cálculo candidata y las etiquetas de la Fase 1 congelada. Es un registro
editorial interno y no se incorpora al documento público. La correspondencia
no implica identidad automática de convenciones.

La Fase 1 define la coordenada seccional $z$ positiva hacia el exterior y
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

Por lo tanto, respecto de la definición seccional escrita en la Fase 1,
$M_\theta^{\mathrm{calc}}=-M_\theta^{\mathrm{F1,def}}$. Respecto del símbolo
empleado en las ecuaciones de equilibrio y compatibilidad de la Fase 1,
$M_\theta^{\mathrm{calc}}=M_\theta^{\mathrm{F1,alg}}$. Las correspondencias de
la tabla para $M_\theta$ se entienden con esta transformación; $N_\theta$ y
$Q_\theta$ conservan sus signos.

| Fórmula de la memoria | Etiquetas de Fase 1 |
|---|---|
| `eq-calculation-standard-thrust` | sin equivalente operativo en Fase 1; USACE EM 1110-2-2902, ec. 4-20; correspondencia con AASHTO 10.ª edición pendiente de comprobar |
| `eq-calculation-depth`, `eq-calculation-vertical-stress` | `eq-depth-theta`, `eq-effective-vertical`, `eq-pore-pressure` |
| `eq-calculation-k0` | `eq-k0-definition` |
| `eq-calculation-k0-reference` | `eq-k0-elastic`, `eq-k0-jaky`; FHWA NHI-05-037, ecs. 5.37--5.38 |
| `eq-calculation-k0-unloading` | sin equivalente en Fase 1; Mayne--Kulhawy (1982), ec. 10; desarrollo académico de $K_0$ |
| `eq-calculation-k0-reloading` | sin equivalente en Fase 1; Mayne--Kulhawy (1982), ec. 18; desarrollo académico de $K_0$ |
| `eq-calculation-k0-passive-limit` | sin equivalente en Fase 1; Mayne--Kulhawy (1982), ecs. 11--12; desarrollo académico de $K_0$ |
| `eq-calculation-compaction-history` | `eq-compaction-history`; separación metodológica ampliada en el desarrollo académico de $K_0$ |
| `eq-calculation-stress-projection`, `eq-calculation-biaxial-load` | `eq-mean-difference`, `eq-normal-pressure`, `eq-tangential-traction` |
| `eq-calculation-tangential-multiplier` | interpola los estados prescritos `eq-normal-pressure` y `eq-tangential-traction`; desarrollo independiente en `TITO/kb/paper-candidate/chapters/methodology.tangential.participation.es.md` |
| `eq-calculation-first-order-system` | `eq-ring-equilibrium-m`, `eq-ring-equilibrium-r`, `eq-ring-equilibrium-t` |
| `eq-calculation-compatibility-constants` | `eq-general-resultants`, `eq-compatibility-conditions`, `eq-compatibility-constants` |
| `eq-calculation-section-stiffness` | `eq-sectional-constitutive-law`, `eq-corrugated-rigidities`, `eq-corrugated-ratio` |
| `eq-calculation-biaxial-alpha-response` | superposición lineal de `eq-k0-normal-response` y `eq-k0-full-response` |
| `eq-calculation-sheet-normal-stress` | desarrollo posterior a la Fase 1; `eq-methodology-sheet-normal-stress` en la ampliación metodológica independiente |
| `eq-calculation-appendix-sheet-normal-stress` | derivación dimensional de `eq-calculation-sheet-normal-stress` con la coordenada $\xi=-y$ |

La correspondencia identifica procedencia y equivalencia conceptual. No
autoriza a modificar las etiquetas ni los archivos congelados de la Fase 1.
