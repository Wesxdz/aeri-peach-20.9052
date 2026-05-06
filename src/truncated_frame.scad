// Aeri Peach 20.9052
include <dodecahedroid_config.scad>

use <pentagon_plate.scad>
use <connector_pentagon_plate.scad>

difference()
{
rotate([-magic_angle, 0, 0])
{
for (i = [0 : 11]) {
    if (true)
    //if(face_groups[i] == 3)
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    PolycarbonateSupportPanel();
    }
    }
}
}