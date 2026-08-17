---
lang: en
title: "Circular lining calculation report"
subtitle: "Deterministic scenario defined by fill height above the crown"
pilotStatus: candidate
---

# Calculation model {#sec-calculation-model}

## Purpose and scope {#sec-calculation-scope}

This report documents the calculation of the section resultants of a circular
lining, expressed per unit projected axial width, for a deterministic scenario
defined by the fill height above the crown, the free-field effective stress
state, and the elastic properties of the backfill. The transverse-section
response is obtained using the Schwartz--Einstein external-loading sequence
for two kinematic interface idealizations: full slip and no slip
[@SchwartzEinstein1980]. These idealizations are not presented as demonstrated
bounds on the response of every real interface.

The calculation determines the circumferential normal force
$N_\theta(\theta)$, circumferential bending moment $M_\theta(\theta)$, and
circumferential shear force $Q_\theta(\theta)$, together with their extreme
values and angular locations. The inputs are assumptions of the numerical
application; they are not presented as results of a characterization of the
existing backfill.

The model is applied separately to the existing corrugated steel plate lining
and to two independent shotcrete alternatives: plain and reinforced. Each
alternative uses its own radius to the wall centroid, section properties, and
stiffnesses. The interaction and resultants are recalculated for each lining
and are not transferred between alternatives. Plain concrete is checked using
the applicable provisions of Chapter 14 of ACI 318-25 [@ACI31825]. The
reinforced alternative is assessed using an ACI 318-25 $P$--$M$ interaction
domain and the minimum area of shell reinforcement adopted from ACI 318.2-14
[@ACI31825; @ACI318214].

Separately, the corrugated steel conduit is checked using an identified
reproduction of an earlier AASHTO procedure published in CIRSOC 804-4
[@CIRSOC8044]. The check determines the factored thrust per unit wall length
and evaluates wall resistance, seam strength, flexibility, and minimum soil
cover above the conduit. This application does not establish compliance with
the current AASHTO edition. The scalar wall thrust and the angle-dependent
resultants arise from different loading formulations and are not combined.

## Common data and conventions {#sec-calculation-basis}

### Scenario data {#sec-calculation-scenario-data}

@tbl-calculation-inputs contains only the common scenario quantities. The fill
height above the crown, the unit weight adopted for effective-stress
calculation, the surcharge, $K_0$, $E_g$, and $\nu_g$ define the free-field
effective stress state and the adopted interaction. The properties of each
lining alternative are presented in the corresponding section-property
tables; those of the corrugated profile are identified in
@tbl-calculation-section-reference.

| $x_i$ | $v_i$ | $u_i$ |
|---|---:|---|
| $H_0$ | 8 | m |
| $R$ | 1.315 | m |
| $\gamma'$ | 19 | kN/m³ |
| $q'$ | 0 | kPa |
| $K_0$ | 0.5 | dimensionless |
| $E_g$ | 30 | MPa |
| $\nu_g$ | 0.3 | dimensionless |

: Common scenario data: $H_0$ is the fill height above the crown; $R$ is the distance from the crown to the geometric center of the circular lining; $\gamma'$ is the unit weight adopted for effective-stress calculation; $q'$ is the surcharge included in that calculation; $K_0$ is the adopted coefficient of earth pressure at rest; and $E_g$ and $\nu_g$ are the elastic parameters of the backfill. {#tbl-calculation-inputs}

In this application, $K_0$ is adopted as a scenario assumption. The
supplementary formulations and their domains are provided in
[Appendix B.3](#sec-calculation-appendix-k0-alternatives). The full-slip and
no-slip interfaces are two discrete kinematic idealizations; they are not
interpolated by a multiplier, and they are not asserted to bound the response
of every real interface.

### Angular coordinate and sign conventions {#sec-calculation-sign-conventions}

The angular coordinate is defined with $\theta=0$ at the crown and positive
clockwise. The radial unit vector $\mathbf e_r$ is positive outward from the
lining, and the tangential unit vector $\mathbf e_t$ follows increasing
$\theta$. Consequently, $P_r>0$ acts outward and $P_t>0$ acts in the direction
of $\mathbf e_t$.

The circumferential normal force is positive in tension. The section
coordinate $\xi$ is positive toward the inner fiber; therefore,
$M_\theta>0$ produces tension in that fiber. On the positive face of the
differential element, whose normal follows $\mathbf e_t$, $Q_\theta>0$ acts
toward the center of the circular section. The radial and tangential
components of the action distributed around the perimeter, $P_r$ and $P_t$,
are expressed in kPa; $N_\theta$ and $Q_\theta$, in kN/m; and $M_\theta$, in
kN·m/m.

### Definition of section resultants {#sec-calculation-resultants-definition}

At a fixed angular position $\theta$, let $A_b$ be the region occupied by
material in the idealized resisting section contained within a strip of
projected axial width $b$, on a cut normal to the circumferential direction.
Let $x_L$ be the axial coordinate and $\xi$ the local radial coordinate
measured from the centroidal axis of that section; $dA$ denotes a
differential element of $A_b$. The shear stress $\tau_{\theta\xi}$ is positive
in the direction of $\xi>0$. The resultants per unit width are defined by

$$
\begin{aligned}
N_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,dA,\\
M_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,\xi\,dA,\\
Q_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\tau_{\theta\xi}(\theta,x_L,\xi)\,dA.
\end{aligned}
$$ {#eq-calculation-resultant-definitions}

In a local Cartesian description, $dA=dx_L\,d\xi$. For the homogeneous
material section considered, the origin of $\xi$ satisfies
$\iint_{A_b}\xi\,dA=0$; $\xi>0$ corresponds to the inner fiber and $\xi<0$ to
the outer fiber. The three expressions are two-dimensional integrals over
$A_b$ at constant $\theta$; they do not integrate around the circumference.

## Adopted stress state and actions {#sec-calculation-actions}

The calculation state is defined by the free-field effective stresses,
evaluated at the depth of the geometric center of the circular lining, and the
Schwartz--Einstein external-loading sequence [@SchwartzEinstein1980]. The
vertical pressure due to fill self-weight is developed in
[Appendix B](#sec-calculation-appendix-actions). The current scenario does not
include a hydraulic action; its consideration requires characterization of
the groundwater level and pore pressure. The deterministic application
represents the final condition of the placed backfill. The temporary action from compaction
equipment belongs to a different construction stage and is not superimposed
on this permanent condition. No residual compaction stress is included because
it has not been characterized for this case.

### Reference vertical effective stress {#sec-calculation-reference-stress}

Let $H_0$ be the fill height measured from ground surface to the crown, and
$R=1.315\ \mathrm{m}$ the distance from the crown to the geometric center of
the circular lining. The reference depth adopted in this application is

$$
z_{ref}=H_0+R.
$$ {#eq-calculation-reference-depth}

The evaluated case represents homogeneous backfill with
$\gamma'=19\ \mathrm{kN/m^3}$, and $q'=0\ \mathrm{kPa}$. The vertical
effective stress at the reference depth is determined by

$$
\sigma'_v(z_{ref})=q'+\gamma' z_{ref},
$$ {#eq-calculation-vertical-effective-stress}

where $q'$ is the surcharge and $\gamma'$ the unit weight assigned directly to
the effective-stress calculation. Depths are expressed in m, unit weights in
kN/m³, and stresses in kPa. The value of $\gamma'$ is not reclassified here as
total or buoyant unit weight. A condition with groundwater or stratigraphy
requires its own inputs and discretization and is not part of this scenario.

### Horizontal effective stress and coefficient $K_0$ {#sec-calculation-k0-estimation}

The coefficient of earth pressure at rest is defined in terms of effective
stresses:

$$
K_0(z_{ref})=\frac{\sigma'_h(z_{ref})}{\sigma'_v(z_{ref})},
\qquad
\sigma'_h(z_{ref})=K_0(z_{ref})\,\sigma'_v(z_{ref}).
$$ {#eq-calculation-k0}

The application adopts a declared value of $K_0$ for the analyzed depth and
stage. Relationships for estimating it from $\nu_g$, $\phi'$, and stress
history are provided in
[Appendix B.3](#sec-calculation-appendix-k0-alternatives); they are not
combined with one another or with the adopted value.
