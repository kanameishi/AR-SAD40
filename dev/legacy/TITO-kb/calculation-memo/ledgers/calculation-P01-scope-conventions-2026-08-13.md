# calculation-P01-scope-conventions-2026-08-13

## Section

Primer paquete de revisión de la memoria: título, objeto y alcance,
convenciones y definición de las resultantes seccionales.

## Report Purpose

Identificar el producto como memoria de un caso analítico determinístico de
referencia y fijar las convenciones necesarias para interpretar sus
resultantes. La audiencia son ingenieros geotécnicos y estructurales.

## Sources Read

- Fuente de verdad del proyecto: `calculation.json` y los productos vigentes
  bajo `data/calculation/`.
- Fuente técnica interna: `dev/SoT/CALCULATION-EQUATION-REGISTER.md`,
  CAL-E01.
- Fuente técnica interna: dictamen de la integral de área en
  `/private/tmp/ar-sad40-eq1-integrals-audit.md`.
- Metodología aprobada, sólo para correspondencia:
  `_chapters/methodology.scope.es.md`.

## Exact Claims Allowed

- El producto documenta el caso `verification-biaxial-uniform`.
- El problema es plano y se formula por unidad de longitud axial.
- Las salidas son $N_\theta(\theta)$, $M_\theta(\theta)$ y
  $Q_\theta(\theta)$, con sus extremos.
- Las acciones corresponden a un estado biaxial uniforme prescrito y a dos
  valores del multiplicador $\alpha$.
- La integral de definición se evalúa sobre el área de una franja a
  $\theta$ fijo y se normaliza por el ancho longitudinal proyectado $b$.
- Las convenciones de signo y las unidades son las registradas en CAL-E01.

## Claims Not Allowed

- Que el caso representa la demanda del revestimiento existente.
- Que se calculó una distribución de contacto del relleno real.
- Que se ejecutaron Monte Carlo, verificación resistente, chapa, juntas,
  pernos u hormigón proyectado.
- Que el contraste numérico constituye validación física.
- Cualquier lista pública de datos pendientes, planes o estados `UNKNOWN`.

## Equations Allowed

Las definiciones normalizadas de $N_\theta(\theta)$ y
$M_\theta(\theta)$ de CAL-E01, con $A_b$, $b$, $dA$, $x_L$ y $\xi$
definidos. El revisor necesita estas ecuaciones para interpretar signos y
unidades. Pertenecen al cuerpo de la memoria.

## Equations Excluded

Acciones perimetrales, equilibrio, compatibilidad, solución cerrada,
Fourier, estimaciones alternativas de $K_0$, recuperación de tensiones y
comprobaciones resistentes. Corresponden a paquetes posteriores o quedan
fuera de la ejecución vigente.

## Vocabulary Allowed

Memoria de cálculo, revestimiento circular, sección transversal, resultantes
seccionales, fuerza normal circunferencial, momento flector circunferencial,
fuerza cortante circunferencial, clave, fibra interior, fibra exterior,
estado biaxial uniforme prescrito y caso analítico determinístico.

## Vocabulary Rejected

`solver`, `pipeline`, `builder`, `helper`, `canónico`, `no-FEM`, guardrail,
metadata, validación física y demanda del revestimiento existente.

## Candidate Public Paragraph Or Section

La versión candidata exacta se conserva fuera de las rutas públicas en
`/private/tmp/ar-sad40-p34-first-review-packet.md` hasta recibir el dictamen
del usuario. Sólo el contenido anterior a «Autoauditoría privada» pertenece a
la candidata pública.

## Candidate Translation Terminology

None: la emisión solicitada está redactada en español.

## Open Gaps

- Aceptación del usuario de la identidad pública como caso analítico
  determinístico de referencia.

## Validation

- La fuente pública vigente y el HTML no se modificaron.
- Registro histórico: este paquete no modificó ni renderizó la metodología.
- La candidata no contiene citas porque sólo fija convenciones y resultados
  propios del cálculo; no atribuye una relación publicada a terceros.
- La reauditoría técnica concluyó `PASS` en
  `/private/tmp/ar-sad40-p34-packet-technical-reaudit.md`.
- La reauditoría editorial concluyó `PASS` en
  `/private/tmp/ar-sad40-p34-packet-editorial-reaudit.md`.
- La promoción queda bloqueada hasta las auditorías técnica y editorial y la
  aprobación explícita del usuario. Las auditorías están cerradas; resta el
  dictamen del usuario.
