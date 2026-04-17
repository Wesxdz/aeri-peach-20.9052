// Giant Peach 20.9052
include <dodecahedroid_config.scad>

include <pentagon_plate.scad>
include <connector_pentagon_plate.scad>
include <fan_panel.scad>
include <wheel_panel.scad>
include <custom_plate.scad>

include <peach_panel.scad>
include <cargo_bay_hatch.scad>

//include <mp_vc_flat.scad>

include <core_platform.scad>
include <camera_panel.scad>
// include <atx_compliance.scad>
// include <vertex_composite.scad>
//include <penta_composite.scad>

//if (true)
//{
//rotate([0, 90+magic_angle, 90])
//translate([-0.5-atx_board_depth , -atx_board_height/2, -16])
//{
//ATXMotherboardMount();
//rotate([0, -90, 0]) ATXSpecification();
//}

//
// TODO: How to mount the PSU to the base?
// rotate([0, 0, 360/6])
//translate([-7, -7, -16.9118+0.5])
//color([.0, 0.5, 1.0, .5])
//PSUVolume();
//}

//include <vertex_composite.scad>
//import("truncated_vertex_composite.stl");

dodecahedron_radius = 1/.688 * panel_radius;
show_cradle_vent = true;
rotate([0, 0, 180])
difference()
{
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) {
    if (true)
    //if(face_groups[i] == 3)
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    TrucatedPlate();
    }
    }
}
translate([0, 0, -29.2]) cylinder(5, 8, 8);
translate([0, 0, -29.5])
hull()
{
    for (i=[0:3])
    {
        rotate([0, 0, 60+i*120]) translate([0, 4, 0]) cylinder(5, 1.0, 1.0);
        rotate([0, 0, 60+i*120]) translate([0, 4, 5]) sphere(1.0);
    }
}
}