# report-methodology-S01-k0-estimation-2026-08-11

## Section

Estimación del coeficiente de empuje en reposo a partir de propiedades del
suelo y de la trayectoria tensional.

## Report Purpose

Documentar las formulaciones aplicables de $K_0$, sus variables primitivas,
sus límites de uso y la separación entre historia tensional y tensión lateral
residual de compactación.

## Sources Read

- Christopher et al. (2006), sección 5.4.9 y ecuaciones 5.37--5.39.
- Mayne y Kulhawy (1982), texto completo y ecuaciones 6--18.
- Michalowski (2005), texto completo y ecuación 8.
- McGrath et al. (1999), ecuación 5.1 y alcance de la acción de compactación.
- CIRSOC 804-4 (2023), artículos 12.7.2.2 y 12.13.2--12.13.3.

## Exact Claims Allowed

$K_0$ se define con tensiones efectivas. La relación abreviada de Jáky
representa carga primaria. Mayne--Kulhawy proponen relaciones diferenciadas
para descarga primaria y descarga seguida de recarga. El coeficiente pasivo de
Rankine establece el límite adoptado por esos autores para la rama de descarga.
La forma de Jáky de 1944 y la crítica de Michalowski se presentan como revisión
histórica, no como una rama probabilística adicional. La acción de compactación
de FHWA-RD-98-191 representa una etapa constructiva y no determina una tensión
residual permanente. $K_0$ caracteriza el estado efectivo inicial; no se
identifica con la presión lateral de contacto de un conducto flexible. La
referencia reglamentaria obtiene el empuje desde $P_F$ en clave y $S$.

## Claims Not Allowed

No atribuir la ecuación de recarga adoptada a FHWA NHI-05-037, cuya ecuación
5.39 difiere de la fuente primaria. No habilitar Brooker--Ireland,
Mesri--Hayat ni una ley cuantitativa de tensión residual sin leer y registrar
evidencia primaria aplicable. No interpretar OCR como indicador automático de
compactación ni combinar dos formulaciones que representen la misma historia.
No añadir a $K_0$ términos de cohesión correspondientes a estados activo o
pasivo. No usar $K_0$ como sustituto de un modelo de interacción.

## Equations Allowed

- $K_0=\sigma'_h/\sigma'_v$ y $\sigma_h=K_0\sigma'_v+u$.
- $K_{0,NC}=1-\sin\phi'$ y la forma de Jáky de 1944 transcrita por
  Michalowski.
- $K_0=\nu_g/(1-\nu_g)$ para la idealización elástica confinada.
- Mayne--Kulhawy, ecuaciones 10, 11--12 y 18.
- Organización de este estudio
  $K_0^{(m)}=f_m(\mathbf{x}_m)$, declarada como tal.
- Separación
  $\sigma'_h=K_{0,b}\sigma'_v+\Delta\sigma'_{h,c}$.

## Equations Excluded

La transcripción de recarga de FHWA NHI-05-037, ecuación 5.39, queda excluida
porque no recupera el límite normalmente consolidado. También quedan fuera
las correlaciones de Brooker--Ireland y Mesri--Hayat y cualquier expresión de
retención residual de compactación aún no sustentada.

## Vocabulary Allowed

Coeficiente de empuje en reposo; tensión efectiva; carga primaria; descarga;
recarga; relación de sobreconsolidación; trayectoria tensional; límite pasivo;
tensión horizontal residual de compactación; rama de formulación.

## Vocabulary Rejected

OCR de compactación como equivalencia automática; $K_0$ aumentado como
sinónimo de tensión residual; rama probabilística para la forma de Jáky de
1944; correlación FHWA para atribuir la ecuación 18 de Mayne--Kulhawy.

## Candidate Public Paragraph Or Section

`TITO/kb/paper-candidate/chapters/methodology.k0.estimation.es.md`.

## Candidate Translation Terminology

None — el candidato se redactó directamente en español. Se conservan OCR,
$K_0$, $K_p$ y las restantes notaciones matemáticas empleadas por las fuentes.

## Open Gaps

Clasificación y propiedades del relleno existente; trayectoria tensional;
OCR y $\mathrm{OCR}_{\max}$; mediciones representativas de $K_0$; modelo y
magnitud de $\Delta\sigma'_{h,c}$; clasificación del producto, $P_F$, $S$ y
formulación de interacción; fuentes primarias para las correlaciones excluidas.

## Validation

CANDIDATO CORREGIDO EL 13 DE AGOSTO DE 2026; ECUACIONES DE $K_0$ Y FORMA DE
JÁKY DE 1944 CONTRASTADAS CON LAS FUENTES REGISTRADAS; PENDIENTE NUEVA
AUDITORÍA DEL ENSAMBLADO.
