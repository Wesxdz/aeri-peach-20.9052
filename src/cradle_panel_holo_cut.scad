include <dodecahedroid_config.scad>
include <Dodecahedron-solid.scad>
use <connector_pentagon_plate.scad>
use <holonomic_mount_panel.scad>
use <din_rail_ts35.scad>
use <plane_slice.scad>

// export rotation orientation
module LowerDINSupport(show_rails=true)
{
rail_pos = [106, -65, -30.48/2*10];
//
scale(10)
//rotate([-tetra_a, 0, 0])
rotate([-magic_angle, 180, 0])
{
for (i = [0 : len(pos)-1]) {

    if (i == 2)
    {
    $fn=36*2;
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    HolonomicMountPanel(lug=true);
    }
}


}
}

LowerDINSupport(false);

//scale(10) import("penta_volume.stl");