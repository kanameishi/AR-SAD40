# Publicación Netlify — AR-SAD40

## objective
2026-08-19 Publicar el alias `report` del manifiesto en Netlify. Condición
observable de fin: URL de producción viva sirviendo html/report/index.html.

## rulings
2026-08-19 Usuario borró a mano el site anterior (UUID 91ca9478-80f2-4cc1-99de-9662102e177b); ese UUID está muerto.
2026-08-19 Usuario autoriza publicar ("publica los sitios"). Efectos cubiertos: --create, deploy, --prod, dominio --https.
2026-08-19 Alcance = solo `report`. `model` excluido: html/model no existe (sin render).

## verdicts
2026-08-19 .netlify/ borrado del repo por pedido del usuario; contenía solo el alias muerto. Verificado ausente.
2026-08-19 Artefacto html/report sano: 497 archivos, 25M, index.html + 8 capítulos + search.json + site_libs.
2026-08-19 Cuenta netlify autenticada: avk@namazu.ai, team averriK. Ningún site arsad40-* existe (0/210).
2026-08-19 dry-run init --create --only report: ok. dry-run deploy --only report: ok.

## runs
2026-08-19 EFECTO COMPLETADO: site Netlify 'arsad40-report' CREADO.
  site_id=8c2dc0ef-070e-4462-9496-649ddd52d0f8  team=averriK
  URL=https://arsad40-report.netlify.app
  Admin=https://app.netlify.com/projects/arsad40-report
  Evidencia: salida de `qrt deploy init --create --only report`, log
  tasks/bw6vyfywt.output. NO volver a crear.

2026-08-19 EFECTO COMPLETADO: alias registrado. .netlify/sites.env contiene
  report=8c2dc0ef-070e-4462-9496-649ddd52d0f8. init exit=0.
2026-08-19 EN CURSO: deploy draft (sin --prod) de html/report, log
  tasks/bjq4z28ap.output. Un redeploy del mismo contenido ES replay-safe.

2026-08-19 EFECTO COMPLETADO: deploy draft ok, 18/18 recursos 200.
2026-08-19 EFECTO COMPLETADO: deploy --prod ok. https://arsad40-report.netlify.app
  verificada 200 en portada, capitulos y search.json. deploy_id=6a85af5aba0b7f68c0725ccc
2026-08-19 verdict: srk.ar es zona DNS gestionada por Netlify en la cuenta
  (dns_zone_id 630914e5fcbfd300a06f2da3), el registro se autocrea al asignar dominio.
2026-08-19 PROXIMO EFECTO: deploy domain --https -> arsad40-report.srk.ar

2026-08-19 EFECTO COMPLETADO: re-render report (08:37:18, 497 archivos, 0 fuentes mas nuevas) tras fin de sesiones Codex concurrentes.
2026-08-19 EFECTO COMPLETADO: draft del render nuevo ok (200 en /, capitulo, search.json).
2026-08-19 EFECTO COMPLETADO: deploy --prod del render nuevo, deploy_id=6a85b2322426c28c8961347e. Verificado: search.json y styles.css byte-identicos al render local; diferencias HTML = Pretty URLs de Netlify.
2026-08-19 EFECTO COMPLETADO: QRT.md parcheado en ~/github/agents (+76 lineas, sin commitear) con las reglas trazadas al incidente.
2026-08-19 PENDIENTE: dominio arsad40-report.srk.ar registrado en zona (id 6a85afbfcd4ed40008f1a95d) pero NS autoritativo aun no lo sirve (~20 min). Netlify ya lo reporta como Production URL. Observar; si no materializa, reportar al usuario — no recrear.

2026-08-19 ruling: usuario objeta el naming 'arsad40-report' (hermanos usan '<proyecto>-es'); slug/dominio nuevos = UNKNOWN, esperando su decision.
2026-08-19 EFECTO EXTERNO (usuario): site 8c2dc0ef BORRADO a mano; registro DNS ya no esta en la zona; netlify.app da 404. Verificado por API.
2026-08-19 EFECTO COMPLETADO: .netlify/ local eliminado de nuevo (alias muerto). El render html/report (08:37) sigue intacto y listo para republicar.

2026-08-19 ruling: usuario pide publicar SIN dominio; el dominio lo hara a mano en la UI (receta entregada).
2026-08-19 verdict: NS1 SI publica registros nuevos (lote IPv6 08:48 servido); el registro de 08:29 quedo atascado individualmente en Netlify. Recrear el vinculo es la palanca.
2026-08-19 verdict: init con --account averriK fallo (createSiteInTeam 404, slug case-sensitive); nada creado. Reintento con 'averrik'.

2026-08-19 EFECTO COMPLETADO: site 'arsad40-report' RECREADO, uuid=93309123-3325-48be-af87-d3786721f782 (account averrik). Alias registrado.
2026-08-19 EFECTO COMPLETADO: report publicado en prod SIN dominio; https://arsad40-report.netlify.app 200; search.json byte-identico al render 08:37.
2026-08-19 ruling: usuario amplia alcance a 'model'.
2026-08-19 verdict: 1er render de model fallo — capitulos leen data/benchmarks/ring/*.csv (5 archivos) que la reorganizacion TITO/kb dejo sin migrar; restaurados desde git HEAD como untracked. Re-render en curso.

2026-08-19 EFECTO COMPLETADO: model renderizado (index.html autocontenido 1.5M) tras restaurar 5 CSV.
2026-08-19 EFECTO COMPLETADO: site 'arsad40-model' creado, uuid=978d1641-7bc3-42a7-96ee-f1fedf2b422e; draft 200; prod https://arsad40-model.netlify.app 200, byte-identico.
2026-08-19 OBJETIVO DE PUBLICACION CUMPLIDO: ambos sitios vivos sin dominio custom; dominios quedan manuales (usuario).
2026-08-19 nueva instruccion: implementar plan de endurecimiento en tools/qrt.

2026-08-19 EFECTO COMPLETADO: plan de endurecimiento IMPLEMENTADO en tools/qrt, commit c482245 (dev, sin push). 14/14 smoke tests + regresion feliz. Docs actualizadas. El build instalado (095e982) NO lo incluye hasta que el usuario reinstale.

## no-replay
2026-08-19 NUNCA volver a correr `deploy init --create` para 'report': el site ya
existe (8c2dc0ef-070e-4462-9496-649ddd52d0f8). Si .netlify/sites.env quedara sin
escribir, registrar el alias con la forma posicional SIN --create:
`qrt deploy init report arsad40-report`.
2026-08-19 UNKNOWN al momento de escribir: si el init terminó de escribir el alias.
Verificar `cat .netlify/sites.env` antes de cualquier reintento.

## next
2026-08-19 verificar URL draft; luego --prod; luego deploy domain --https.
