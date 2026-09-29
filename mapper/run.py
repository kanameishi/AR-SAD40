#!/usr/bin/env python
"""Regional seismicity map - byEvent.

Reads project parameters from ../params.yml (params.mapper section required).
Generates the HTML map under ./byEvent/.

Required params.yml keys:
    params.latitude, params.longitude
    params.site, params.location
    params.client.name
    params.mapper.radius_km
    params.mapper.mw_min, params.mapper.mw_max   (filter eventos via vmin/vmax)
    optional mapper/sites.csv or mapper/locations.csv with fixed site columns

Mag/depth bins, sizes, and colors are universal PSHA conventions
(see scales.py); they do NOT depend on project parameters.
"""
import csv
import sys
import yaml
from pathlib import Path
from kashima.mapper import buildMap, getMasterIndexPath

ROOT = Path(__file__).resolve().parent
GMDB_INDEX_PATH = getMasterIndexPath()
sys.path.insert(0, str(ROOT))
from scales import (
    MAG_BINS, DEPTH_BINS,
    DOT_SIZES, BEACHBALL_SIZES,
    DOT_PALETTE, FAULT_STYLE_META,
)

P = yaml.safe_load((ROOT.parent / "params.yml").read_text())["params"]
if "mapper" not in P:
    raise SystemExit(
        "[mapper] params.yml missing 'mapper:' section — "
        "required keys: radius_km, mw_min, mw_max"
    )
M = P["mapper"]


def hasSiteRows(path):
    COLS = [
        "SiteID", "SiteName", "SiteDescription",
        "SiteLatitude", "SiteLongitude",
    ]
    with path.open(newline="") as FILE:
        Reader = csv.DictReader(FILE)
        if Reader.fieldnames != COLS:
            raise SystemExit(
                f"[mapper] {path.name} must use header: {','.join(COLS)}"
            )
        for ROW in Reader:
            if any(str(v).strip() for v in ROW.values()):
                return True
    return False


def findSitesPath(root):
    for FileName in ("sites.csv", "locations.csv"):
        PathCandidate = root / FileName
        if PathCandidate.is_file() and hasSiteRows(PathCandidate):
            return str(PathCandidate)
    return None


common = dict(
    latitude=P["latitude"], longitude=P["longitude"],
    radius_km=M["radius_km"],
    project_name=f"{P['site']}, {P['location']}",
    client=P["client"]["name"],
    sitesPath=findSitesPath(ROOT),
    vmin=M["mw_min"], vmax=M["mw_max"],
    mag_bins=MAG_BINS, depth_bins=DEPTH_BINS,
    dot_sizes=DOT_SIZES, beachball_sizes=BEACHBALL_SIZES,
    dot_palette=DOT_PALETTE, fault_style_meta=FAULT_STYLE_META,
    min_zoom_level=7, max_zoom_level=15,
    default_tile_layer="Esri.WorldImagery",
    show_faults_default=False,
    show_epicentral_circles_default=True,
    epicentral_circles=20, lock_pan=True,
    heatmap_radius=25, heatmap_blur=15, heatmap_min_opacity=0.50,
    keep_data=False,
)

# ── byEvent: events colored by depth, sized by magnitude ────────────────────
buildMap(
    **common,
    output_dir=str(ROOT / "byEvent"),
    color_by="depth",
    show_events_default=True, show_heatmap_default=False,
    show_beachballs_default=True, show_cluster_default=False,
    show_stations_default=True,
    gmdb_index_path=str(GMDB_INDEX_PATH),
    base_zoom_level=9, auto_fit_bounds=True,
    legend="both", legend_width=100,
)
