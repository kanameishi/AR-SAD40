La rama AASHTO/USACE de la chapa corrugada utiliza una demanda
circunferencial escalar. Para un relleno homogéneo, la presión vertical de
carga permanente en la clave es

$$
P_{FD}=\gamma H_0,
$$ {#eq-calculation-prism-pressure}

donde $\gamma$ es el peso unitario de la carga permanente y $H_0$ es la
altura de relleno sobre la clave. El empuje circunferencial de diseño se
obtiene mediante

$$
T_f=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_L}{2},
\qquad
T_u=\eta_{cmp}T_f,
$$ {#eq-calculation-aashto-design-thrust}

donde $S$ es la luz, $P_{FL}$ es la presión vertical de carga móvil en la
clave, $C_L$ es el ancho cargado, $F_L$ es el factor de distribución de la
carga móvil, $\gamma_{DL}$ y $\gamma_{LL}$ son los factores de carga y
$\eta_{cmp}$ es el modificador adoptado para la demanda
[@USACE2020, sec. 4.12.3.1.1, ec. 4-20; @AndersonEtAl2023, p. 164].

$T_u$ es la demanda común de las comprobaciones de fluencia, pandeo y costura
de la @tbl-liner-aashto-checks. El valor de servicio y la demanda mayorada se
incluyen también en la tabla de la chapa de
@sec-calculation-appendix-references. La relación AASHTO/USACE entrega una
fuerza circunferencial; por ello no genera valores de momento ni de corte en
esa comparación.
