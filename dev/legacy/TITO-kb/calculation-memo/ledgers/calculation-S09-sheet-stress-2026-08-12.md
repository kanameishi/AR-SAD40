# Registro de sección — recuperación de tensión normal circunferencial

## Section

Recuperación condicionada de la tensión normal de la chapa a partir de
$N_\theta$ y $M_\theta$.

## Report Purpose

Incorporar a la memoria la fórmula operativa, las convenciones, las unidades,
las entradas requeridas y el estado de aplicación, sin presentar una tensión o
una comprobación resistente que los datos disponibles no permiten calcular.

## Sources Read

- Mai (2013), capítulos 2--6 y apéndice E.
- United States Bureau of Reclamation, Engineering Monograph No. 14, p. 6.
- NCSPA (2018), tabla 2.6.
- Auditoría de correspondencia G10.2.

## Exact Claims Allowed

La tensión normal homogeneizada puede recuperarse desde $N_\theta$ y
$M_\theta$ cuando se conocen la sección neta, las fibras y la aplicabilidad de
la hipótesis lineal frente a la curvatura. La relación no utiliza
$Q_\theta$. Las propiedades nominales del escenario no caracterizan la sección
corroída existente.

## Claims Not Allowed

No informar tensiones del caso, utilización, factor de seguridad, tensión
equivalente, corte local, pandeo, costuras, juntas ni pernos. No identificar el
espesor nominal con el espesor neto actual.

## Equations Allowed

- $\sigma_\theta=N_\theta/\bar A_n+1000M_\theta\xi/\bar I_n$ en la convención
  de la memoria;
- forma equivalente con $y=-\xi$;
- derivación desde deformación lineal, área e inercia netas; y
- evaluación en ambas fibras con extremos firmados.

## Open Gaps

$\bar A_n$, $\bar I_n$, $\xi_i$, $\xi_o$, regla para representar la
variación angular de la sección neta, criterio de curvatura, producto, norma,
acero, combinaciones y estados límite.

## Validation

La auditoría técnica concluyó `PASS` en
`/private/tmp/ar-sad40-sheet-memo-technical-audit.md`. La primera auditoría
editorial detectó referencias internas entre productos y una condición de
aplicación incompleta en A.6; esas observaciones se corrigieron antes del
dictamen final `PASS` en
`/private/tmp/ar-sad40-sheet-memo-editorial-reaudit.md`. El HTML auditado tiene
SHA-256
`10a249fc6604da90e1b4f6b9b2c69600c1d77ae0b5c9f5d919f1a531ee651f29`.
No presenta tensiones ni resistencia del caso mientras las entradas
obligatorias permanezcan sin definir.
