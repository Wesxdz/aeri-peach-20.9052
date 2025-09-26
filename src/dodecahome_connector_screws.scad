include <dodecahedroid_config.scad>
include <pentagon_plate.scad>
include <connector_pentagon_plate.scad>

rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) {
    // if (face_groups[i] == 1 || face_groups[i] == 0)
    if (face_groups[i] == 2 || face_groups[i] == 3)
    {
    // these screws are not far out enough
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    ConnectorPentagonPlateScrews(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)]);
    }
}
}
