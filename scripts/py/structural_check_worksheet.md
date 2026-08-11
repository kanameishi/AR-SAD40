# Circular tunnel lining — manual verification worksheet

Companion to `circular_tunnel_lining_loads.ipynb`. Every number below was
copied from that notebook's actual (executed) output — nothing here is
re-derived independently — so this is a hand-checkable record of what the
notebook computed, not a second implementation.

Method: Núñez (1996) semi-empirical closed-form solution, as reproduced in
Núñez, Sfriso & Laiún (2014), *Fifteen years of experience with the
estimation of structural loadings acting on temporary supports of tunnels in
Buenos Aires*, WTC 2014.

**Sign convention: compression positive**, throughout (inherited from the
source geotechnical formulas). Lengths in m, unit weight in kN/m³, stresses/
moduli in kPa, so N comes out in kN/m and M in kN·m/m (both per metre of
tunnel length).

---

## 1. Configuration A — concrete lining

### 1.1 Inputs

| Symbol | Meaning | Value | Units |
|---|---|---|---|
| D | tunnel diameter | 10.0 | m |
| H | overburden | 18.0 | m |
| γ | soil unit weight | 19.0 | kN/m³ |
| q | surface surcharge | 20.0 | kPa |
| K0 | at-rest stress ratio | 0.60 | – |
| η | stress-relaxation coefficient | 0.50 | – |
| EI | lining flexural stiffness (direct input) | 5859.375 | kN·m²/m |
| EA | lining normal stiffness (direct input, unused by the load eqs.) | 3,125,000 | kN/m |
| Es | soil Young's modulus | 168,750 | kPa |
| νs | soil Poisson's ratio | 0.25 | – |
| χ | contact factor (1.0 = smooth/primary) | 1.0 | – |

`EI`/`EA` are traceable to a 150 mm shotcrete lining, Er = 20 GPa, νr = 0.20
(kept only as a derivation record — not needed once EI, EA are given
directly):

```
Er0 = Er / (1 - νr²) = 20,000,000 / (1 - 0.20²) = 20,833,333 kPa
I   = e³/12 = 0.15³/12 = 0.0002812500 m⁴/m
A   = e = 0.15 m²/m
EI  = Er0 · I = 20,833,333 × 0.00028125  = 5,859.375 kN·m²/m
EA  = Er0 · A = 20,833,333 × 0.15        = 3,125,000  kN/m
```

`Es` is back-calculated from the source paper's published Es0 = 180 MPa
(Case 1 of its Table 2), assuming νs = 0.25:
`Es = Es0 · (1 - νs²) = 180,000 × (1 - 0.0625) = 168,750 kPa`

### 1.2 Step-by-step calculation (Eqs. 6–25)

```
Eq.6   σv     = γ·H + q = 19.0×18.0 + 20.0                          = 362.0 kPa

Eq.7   σr0    = η·σv = 0.50 × 362.0                                 = 181.0 kPa

Eq.9   σv⁽¹⁾  = K0·η·σv = 0.60×0.50×362.0                           = 108.6 kPa
               (= free-field σh, isotropic/compression-only part)

Eq.10  pv     = σv⁽²⁾ = (1-K0)·η·σv = 0.40×0.50×362.0               = 72.4 kPa
               (deviatoric part, drives bending)

Eq.14  Es0    = Es/(1-νs²) = 168,750/(1-0.25²) = 168,750/0.9375     = 180,000 kPa

Eq.17  K      = χ·Es0/D = 1.0×180,000/10.0                          = 18,000 kPa/m

a-fac  a      = 192·EI/(χ·Es0·D³) = 192×5859.375/(1×180,000×1000)
              = 1,125,000 / 180,000,000                             = 0.00625
               (general form, derived from Eq.19 using EI directly —
                drops the paper's extra (1-νs²)/(1-νr²) factor, which
                can't be reconstructed once νr isn't tracked; ~2-10%
                effect for typical νr, νs — see notebook §6)

Eq.20  Δσ     = a/(1+a)·pv = (0.00625/1.00625)×72.4
              = 0.0062112 × 72.4                                    = 0.4497 kPa

Eq.21  Mmax   = (1/16)·Δσ·D² = (1/16)×0.4497×100                    = 2.811 kN·m/m
               (positive at crown, negative same magnitude at equator)

Eq.23  N_A    = 0.5·η·D·σv = 0.5×0.50×10.0×362.0                    = 905.0 kN/m
               (equator)

Eq.24  N_C    = 0.5·η·D·σv·(K0 + (2/3)(1-K0)/(1+a)) − (1/12)·K0·γ·D²
              = 905.0×(0.60 + 0.66667×0.40/1.00625) − (1/12)×0.60×19.0×100
              = 905.0×(0.60 + 0.264995) − 95.0
              = 905.0×0.864995 − 95.0
              = 782.82 − 95.0                                       = 687.8 kN/m
               (crown)

Eq.25  N_I    = 0.5·η·D·σv·(K0 + (4/3)(1-K0)/(1+a)) + (1/12)·K0·γ·D²
              = 905.0×(0.60 + 1.33333×0.40/1.00625) + 95.0
              = 905.0×(0.60 + 0.529991) + 95.0
              = 905.0×1.129991 + 95.0
              = 1022.64 + 95.0                                      = 1117.6 kN/m
               (invert; notebook's full double-precision value is 1117.7 —
                small (~0.1%) differences here are from rounding at each
                hand-calc step, not a discrepancy in method)
```

### 1.3 Results summary

| Position | N [kN/m] | M [kN·m/m] |
|---|---|---|
| Crown | 687.8 | +2.811 |
| Equator | 905.0 | −2.811 |
| Invert | 1117.7 (hand-calc above: 1117.6, rounding) | 0.000 |

Cross-check: Eq. 22 (direct closed form combining Eqs. 6, 20, 21) reproduces
the same Mmax = 2.811 kN·m/m independently — confirms Eqs. 20+21 are applied
consistently.

For reference, the source paper's Table 3 (Case 1, different assumed
material properties) reports Nc=620, Na=670, Mc=4.8, Ma=5.9 — not expected
to match exactly; see notebook §11 for the reconciliation (Na alone implies
γ≈13.8 kN/m³, vs. 19.0 assumed here).

---

## 2. N-M interaction diagram (concrete capacity check)

Simplified piecewise-linear ("rhomboid") envelope, four vertices in
(N, M) space — **N compression-positive**:

| Vertex | N [kN/m] | M [kN·m/m] | Meaning |
|---|---|---|---|
| 1 | N⁻ = 0.0 | 0 | pure tension capacity (placeholder: none assumed) |
| 2 | Np = 700.0 | +Mp = +4.5 | corner — peak positive moment capacity |
| 3 | N⁺ = 1500.0 | 0 | pure compression capacity ("squash load") |
| 4 | Np = 700.0 | −Mp = −4.5 | corner — peak negative moment capacity |

**All four values (0, 700, 1500, 4.5) are illustrative placeholders** —
replace with values from an actual N-M interaction check per the applicable
design code before using this for a real decision.

Available moment capacity at a given axial force N (two linear segments):

```
if N <= Np:   M_capacity(N) = Mp · (N - N⁻) / (Np - N⁻)
if N >  Np:   M_capacity(N) = Mp · (N⁺ - N) / (N⁺ - Np)
outside [N⁻, N⁺]:  M_capacity = 0   (axial capacity alone already exceeded)
```

Safety: point (N, M) is inside the envelope, i.e. safe, iff
`N⁻ ≤ N ≤ N⁺` and `|M| ≤ M_capacity(N)`. Checked at all three locations:

```
CROWN    N = 687.8   (≤ Np=700, left segment)
         M_capacity = 4.5 × (687.8 - 0) / (700 - 0)  = 4.5 × 0.9826  = 4.422 kN·m/m
         |M| = 2.811       utilization = 2.811 / 4.422             = 0.64   SAFE

EQUATOR  N = 905.0   (> Np=700, right segment)
         M_capacity = 4.5 × (1500 - 905.0) / (1500 - 700) = 4.5 × 0.74375 = 3.347 kN·m/m
         |M| = 2.811       utilization = 2.811 / 3.347             = 0.84   SAFE (governs)

INVERT   N = 1117.7  (notebook's precise value; > Np=700, right segment)
         M_capacity = 4.5 × (1500 - 1117.7) / (1500 - 700) = 4.5 × 0.4779 = 2.151 kN·m/m
         M = 0              utilization = 0 / 2.151                = 0.00   SAFE
         (equivalently, since M=0 here always: is N ≤ N⁺=1500? 1117.7 ≤ 1500 → SAFE)
```

Equator governs among the three (highest utilization, 0.84), consistent
with the Part II reliability results below.

---

## 3. Configuration B — corrugated steel lining

### 3.1 Inputs

| Symbol | Meaning | Value | Units |
|---|---|---|---|
| D, H, γ, q, K0, η, Es, νs | same as Configuration A | — | — |
| χ | contact factor (2.0 = rough/mechanically interlocked) | 2.0 | – |
| t | plate thickness | 0.005 | m |
| Es_steel | steel Young's modulus | 200,000,000 | kPa |
| νsteel | steel Poisson's ratio | 0.30 | – |
| corrugation depth / pitch | 152×51 mm AASHTO/CSPI structural-plate profile | 0.051 / 0.152 | m |

### 3.2 Section properties (sinusoidal-corrugation approximation)

```
h = depth/2 = 0.0255 m
I = t·h²/2 = 0.005 × 0.0255² / 2                              = 1.626e-06 m⁴/m
A = t·(1 + π²h²/pitch²) = 0.005×(1 + π²×0.0255²/0.152²)        = 0.006389 m²/m
W = I/h = 1.626e-06 / 0.0255                                   = 6.375e-05 m³/m
Er0 = Es_steel/(1-νsteel²) = 200,000,000/(1-0.09)               = 219,780,220 kPa
EI = Er0·I = 219,780,220 × 1.626e-06                            = 357.3 kN·m²/m
EA = Er0·A = 219,780,220 × 0.006389                             = 1,404,000 kN/m
```

### 3.3 Loads (same Eqs. 6–25, EI = 357.3 instead of 5859.375)

```
a = 192×357.3/(2.0×180,000×1000)  = 68,601.6/360,000,000        = 0.0001905
```

| Position | N [kN/m] | M [kN·m/m] |
|---|---|---|
| Crown | 689.3 | +0.08621 |
| Equator | 905.0 | −0.08621 |
| Invert | 1121 | 0.000 |

The steel section's flexural rigidity (EI=357) is ~16× lower than
concrete's (EI=5859) despite steel's ~10× higher modulus — the flexible-
design effect (§9 of the notebook): a thin corrugated plate sheds bending
moment to the ground rather than resisting it.

### 3.4 Capacity checks (unchanged stress/thrust checks, not an interaction diagram)

```
σ_crown   = N_crown/A + |M_crown|/W = 689.3/0.006389 + 0.08621/6.375e-05  = 109,200 kPa
σ_equator = N_equator/A + |M_equator|/W = 905.0/0.006389 + 0.08621/6.375e-05 = 143,000 kPa   (governs)
σ_max = 143,000 kPa

Fy (yield strength, placeholder)          = 230,000 kPa   → utilization = 143,000/230,000 = 0.62
seam_capacity (placeholder)               = 1,750 kN/m    → utilization = 1121/1750       = 0.64
```

---

## 4. Part II — probabilistic inputs (for reference; not hand-checkable)

FORM/Monte Carlo results are inherently numerical (nonlinear optimization /
20,000–200,000 simulated draws), so they aren't meant to be re-derived by
hand — listed here only so the input assumptions are visible without
opening the notebook.

### 4.1 Concrete random variables

| Variable | Distribution | Mean | CoV |
|---|---|---|---|
| D | normal | 10.0 m | 0.5% |
| H | normal | 18.0 m | 5.6% |
| γ | normal | 19.0 kN/m³ | 5.3% |
| q | triangular (0 / 20 / 40) | 20.0 kPa | 40.8% |
| K0 | triangular (0.45 / 0.60 / 0.75) | 0.60 | 10.2% |
| η | triangular (1/3 / 0.50 / 2/3) | 0.50 | 13.6% |
| Es | lognormal | 168,750 kPa | 30% |
| νs | uniform (0.20–0.30) | 0.25 | 11.5% |
| χ | uniform (1.0–2.0) | 1.5 | 19.2% |
| EI | lognormal | 5859.375 kN·m²/m | 20% |
| EA | lognormal | 3,125,000 kN/m | 20% |
| N_compression_cap | lognormal | 1500 kN/m | 20% |
| Np | lognormal | 700 kN/m | 20% |
| Mp | lognormal | 4.5 kN·m/m | 20% |

(N_tension_cap is fixed at 0, not randomized — a modelling assumption, not
an aleatory quantity.)

### 4.2 FORM results (concrete) — β / Pf per limit state

| Limit state | β | Pf (FORM) | Pf (crude MC, N=200,000) |
|---|---|---|---|
| N-M interaction @ crown | 1.314 | 0.0944 | 0.1197 |
| **N-M interaction @ equator (governing)** | **0.692** | **0.2446** | **0.2558** |
| Axial capacity @ invert | 1.112 | 0.1331 | 0.1220 |

Top importance factors for the governing check (equator): η (33%), Es
(14%), χ (12%), N_compression_cap (11%), Mp (6%), EI (6%), Np (5%).

### 4.3 FORM results (corrugated steel) — for reference

| Limit state | β | Pf (FORM) | Pf (crude MC) |
|---|---|---|---|
| Plate yield (Fy) | 2.523 | 0.00582 | 0.00423 |
| **Bolted seam (governing)** | **1.734** | **0.0414** | **0.0358** |

---

## 5. Caveats carried over from the notebook

- Valid for **circular** linings, no water pressure, soils with little
  plastic yielding. Not the extended elliptical/water-pressure version of
  Núñez (2000).
- The `a_factor` formula used here is the *general* form derived from
  Eq. 19 (`192·EI/(χ·Es0·D³)`), not the paper's literal Eq. 20 — the
  latter has an extra `(1-νs²)/(1-νr²)` factor that can't be reconstructed
  once EI is given directly instead of e, Er, νr separately (~2–10% effect
  for typical νr, νs).
- **Corrugated steel is a modelling extrapolation**: Núñez's method was
  validated for small-deflection concrete/shotcrete linings only. Treat
  the corrugated-steel numbers as relative/preliminary, not a substitute
  for Iowa/Spangler, AASHTO LRFD §12, or CANDE-type FEM.
- All capacity values (N_compression_cap, Np, Mp, Fy, seam_capacity) are
  **illustrative placeholders** — replace with values from an actual
  code-compliant capacity check before using this for a real design
  decision.
- FORM limit states are simplified stress/force checks — no
  reinforcement/lattice girders, creep, buckling, or long-term strength
  gain. β/Pf are illustrative, for ranking variable importance, not a
  pass/fail design verification.
