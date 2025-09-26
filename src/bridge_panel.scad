include <dodecahedroid_config.scad>
include <pentagon_plate.scad>
include <connector_pentagon_plate.scad>

scale(10) ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true, [0, 1, 1, 1], m3_distance_from_panel_corner, [4, 4, 4, 4, 4], [0, 0, 1, 0, 1]);