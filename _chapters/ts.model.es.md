Los modelos de desplazamiento de bloque flexible evalúan la demanda espectral en períodos proporcionales al período fundamental de la masa potencialmente deslizante. Para cada combinación de geometría y material, $T_s$ se obtiene a partir de la geometría del talud y de la variación del módulo de corte de pequeña deformación con la profundidad, representada por $G_o$, $m_o$ y $V_S^o$. Los valores medios de $T_s$ y $V_{S30}$ caracterizan la respuesta dinámica empleada en los modelos de desplazamiento del capítulo dedicado a los desplazamientos permanentes.

El período fundamental de la masa potencialmente deslizante se representa mediante el primer modo de una viga de corte inhomogénea truncada [-@DakoulasGazetas1985Inhomogeneous]:

$$
T_s=\frac{4\pi H_s}{a_1(2-m_o)V_S^o}.
$${#eq-slope-period}

En la expresión [-@eq-slope-period], $H_s$ es la altura del talud; $V_S^o$ es la velocidad de onda de corte correspondiente al módulo basal $G_o$; $m_o$ es el exponente del perfil de rigidez; y $a_1$ es la primera raíz de la ecuación característica. El valor de $a_1$ depende conjuntamente de $m_o$ y de la razón de truncamiento $\lambda_o$.

La razón de truncamiento $\lambda_o$ puede expresarse, por semejanza geométrica, según la expresión [-@eq-slope-truncation], donde $b$ es el ancho de la berma y $b_{\max}$ es el ancho de la base.

$$
\lambda_o=\frac{b}{b_{\max}}.
$${#eq-slope-truncation}

Para la sección truncada equivalente del modelo de Dakoulas y Gazetas [-@DakoulasGazetas1985Inhomogeneous], la altura $H_s$, la relación de talud $s$ y la razón de truncamiento $\lambda_o$ determinan el ancho $b$ de la berma y el ancho $b_{\max}$ de la base según las expresiones [-@eq-slope-berm-width] y [-@eq-slope-base-width], respectivamente; la relación de talud se define por $\tan\beta=1/s$, con $\beta$ el ángulo del talud.

$$
b=\frac{2H_s s}{1/\lambda_o-1}.
$${#eq-slope-berm-width}

$$
b_{\max}=b+2H_s s.
$${#eq-slope-base-width}

En cada realización, la velocidad basal de onda de corte $V_S^o$ se obtiene según la expresión [-@eq-slope-basal-velocity], donde $G_o$ es el módulo basal ajustado, $g$ es la aceleración de la gravedad y $\gamma_{\mathrm{sat}}^{(k_{\mathrm{b}})}$ es el peso unitario saturado de la capa basal, cuyo índice es $k_{\mathrm{b}}$, con las magnitudes expresadas en unidades consistentes.

$$
V_S^o=\left(\frac{gG_o}{\gamma_{\mathrm{sat}}^{(k_{\mathrm{b}})}}\right)^{1/2}.
$${#eq-slope-basal-velocity}

El perfil de rigidez de cada realización se representa según la expresión [-@eq-slope-profile], donde $z$ es la profundidad medida desde la coronación, $G_o$ es el módulo ajustado en $z/H_s=1$ y $m_o$ es el exponente obtenido del ajuste logarítmico de los módulos de capa $G_m^{(k)}$.

$$
G(z)=G_o\left(\frac{z}{H_s}\right)^{m_o}.
$${#eq-slope-profile}

La clasificación USCS de la capa $k$ determina su familia constitutiva y las $J^{(k)}$ formulaciones tabuladas de rigidez [-@Ishihara1996]. El módulo adoptado para la capa corresponde a la media aritmética definida por la expresión [-@eq-slope-modulus], donde $A^{(j)}$ y $n^{(j)}$ son parámetros tabulados, $F_e^{(k,j)}$ es el factor de relación de vacíos, $m_1^{(k)}$ es el exponente de sobreconsolidación, $p_m^{(k)}$ es la tensión normal octaédrica efectiva promediada en el espesor de la capa y $p_{\mathrm{ref}}=100$ kPa es la presión de normalización.

$$
G_m^{(k)}=\frac{1}{J^{(k)}}\sum_{j=1}^{J^{(k)}}
A^{(j)}F_e^{(k,j)}
\left[\mathrm{OCR}^{(k)}\right]^{m_1^{(k)}}
p_{\mathrm{ref}}^{n^{(j)}}
\left(\frac{p_m^{(k)}}{p_{\mathrm{ref}}}\right)^{n^{(j)}}.
$${#eq-slope-modulus}

La tensión normal octaédrica efectiva, promediada en el espesor de la capa $k$, $p_m^{(k)}$ [-@HardinBlack1968; -@HardinDrnevich1972], se obtiene, para el estado de esfuerzos en reposo, según la expresión [-@eq-slope-mean-pressure], donde $K_0$ es el coeficiente de presión lateral en reposo, $\gamma^{(\ell)}$ y $h^{(\ell)}$ son el peso unitario correspondiente a la condición freática y el espesor de la capa $\ell$, y $\ell<k$ identifica las capas suprayacentes.

$$
p_m^{(k)}=\frac{1+2K_0}{3}
\left(\sum_{\ell=1}^{k-1}\gamma^{(\ell)}h^{(\ell)}
+\frac{\gamma^{(k)}h^{(k)}}{2}\right).
$${#eq-slope-mean-pressure}

La razón de sobreconsolidación $\mathrm{OCR}^{(k)}=\max[(p_m^{(k)}+\mathrm{POP})/p_m^{(k)},1]$, donde $\mathrm{POP}$ es la presión de preconsolidación, sólo modifica el módulo de los suelos finos: en ellos $m_1^{(k)}=f_{\mathrm{IP}}(\mathrm{IP}^{(k)})$, mientras que en arenas y gravas $m_1^{(k)}=0$ y $[\mathrm{OCR}^{(k)}]^{m_1^{(k)}}=1$. La relación de vacíos $e_0^{(k)}$ interviene en las tres familias mediante $F_e^{(k,j)}$.

En las formulaciones tabuladas [-@Ishihara1996], el factor $F_e^{(k,j)}$ se define mediante [-@eq-slope-void-factor] a partir de la relación de vacíos $e_0^{(k)}$ y del parámetro $C_e^{(j)}$; $j_{\mathrm{SS75}}$ identifica la formulación de Shibata y Soelarno [-@ShibataSoelarno1975].

$$
F_e^{(k,j)}=
\begin{cases}
C_e^{(j)}-\dfrac{e_0^{(k)}}{1+e_0^{(k)}}, & j=j_{\mathrm{SS75}},\\[6pt]
\dfrac{\left(C_e^{(j)}-e_0^{(k)}\right)^2}{1+e_0^{(k)}}, & j\ne j_{\mathrm{SS75}}.
\end{cases}
$${#eq-slope-void-factor}

La velocidad de onda de corte $V_S^{(k)}$ de la capa $k$ se obtiene según la expresión [-@eq-slope-layer-velocity], donde $G_m^{(k)}$ es el módulo adoptado para la capa, $\gamma_{\mathrm{sat}}^{(k)}$ es su peso unitario saturado y las magnitudes se expresan en unidades consistentes.

$$
V_S^{(k)}=\left(\frac{gG_m^{(k)}}{\gamma_{\mathrm{sat}}^{(k)}}\right)^{1/2}.
$${#eq-slope-layer-velocity}

{{< include /_tbl/SiteGo.ES.qmd >}}

Para cada combinación de geometría y material se generan $N$ realizaciones sintéticas del perfil estratificado. Los valores de $G_o$, $m_o$, $V_S^o$ y $V_{S30}$ se resumen separadamente mediante la media y los fractiles marginales. Para la media y cada fractil marginal, $a_1$ y $T_s$ se evalúan con los valores correspondientes de $m_o$ y $V_S^o$; las estimaciones basadas en la media proporcionan las propiedades dinámicas empleadas por los modelos de desplazamiento.

El valor de $V_{S30}$ se obtiene por tiempo de viaje según la expresión [-@eq-slope-vs30], donde $h_{30}^{(i)}$ es el espesor de la capa $i$ comprendido en los primeros 30 m, $V_S^{(i)}$ es su velocidad de onda de corte y $V_{\mathrm{ref}}$ es la velocidad asignada al espesor complementario cuando $H_s<30$ m.

$$
V_{S30}=\frac{30}{
\displaystyle\sum_i\frac{h_{30}^{(i)}}{V_S^{(i)}}
+\dfrac{\max(30-H_s,0)}{V_{\mathrm{ref}}}}.
$${#eq-slope-vs30}
