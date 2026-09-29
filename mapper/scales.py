"""Mapper scales — universal PSHA conventions for kashima.mapper.

These constants are fixed across projects. Project-specific filtering of
which events show up on the map is done via vmin/vmax in run.py
(passed to buildMap as kwargs).

# Bin design — data-driven from kashima.mapper catalogs
# (GCMT 69k events, ISC 468k, USGS 302k events)

# MAGNITUDE bins — 5 inner + ">=8.5" tail = 6 keys
#   3.5-4.5  empty in current catalogs (catalog floor is Mw 4.5);
#            kept as future-proof for local catalogs / microseismicity
#   4.5-5.5  72-92% of all events (densest bin)
#   5.5-6.5  7-25%
#   6.5-7.5  ~1-3%
#   7.5-8.5  ~0.1-0.3%
#   >=8.5    ~0% (megathrust max-credible)

# DEPTH bins — 5 inner + ">=300" tail = 6 keys
# Canonical USGS/ISC classification has only 3 classes:
#   Shallow:        0-70 km
#   Intermediate:   70-300 km
#   Deep:           >=300 km
# Our 6-bin breakdown subdivides those classes for visual granularity:
#   0-15    Shallow — captures default-depth artifact at 10 km + true near-surface
#   15-30   Shallow — mid-crust to Moho (continental Moho ~30-35 km)
#   30-70   Shallow — sub-Moho / subduction interface where applicable
#   70-150  Intermediate-depth (slab in subduction context)
#   150-300 Intermediate-depth (deeper slab)
#   >=300   Deep (canonical regime; events tail off near 700 km physical limit)
"""

MAG_BINS   = [3.5, 4.5, 5.5, 6.5, 7.5, 8.5]
DEPTH_BINS = [0,   15,  30,  70,  150, 300]

DOT_SIZES = {
    "3.5-4.5": 2,
    "4.5-5.5": 4,
    "5.5-6.5": 7,
    "6.5-7.5": 11,
    "7.5-8.5": 16,
    ">=8.5":   22,
}

BEACHBALL_SIZES = {
    "3.5-4.5": 14,
    "4.5-5.5": 22,
    "5.5-6.5": 30,
    "6.5-7.5": 38,
    "7.5-8.5": 46,
    ">=8.5":   54,
}

DOT_PALETTE = {
    "0-15":    "#f46d43",
    "15-30":   "#fdae61",
    "30-70":   "#fee08b",
    "70-150":  "#e6f598",
    "150-300": "#66c2a5",
    ">=300":   "#3288bd",
}

FAULT_STYLE_META = {
    "N":   {"label": "Normal",              "color": "#3182bd"},
    "R":   {"label": "Reverse",             "color": "#de2d26"},
    "SS":  {"label": "Strike-slip",         "color": "#31a354"},
    "NSS": {"label": "Normal-Strike-slip",  "color": "#6baed6"},
    "RSS": {"label": "Reverse-Strike-slip", "color": "#fc9272"},
    "O":   {"label": "Oblique",             "color": "#bdbdbd"},
    "U":   {"label": "Undetermined",        "color": "#969696"},
}
