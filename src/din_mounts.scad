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
//rotate([0, 180, 0])
difference()
{

slice_above(-60)
{
    scale(10)
    //rotate([-tetra_a, 0, 0])
    rotate([0, 180, 180])
    rotate([0, 0, 180])
    rotate([-magic_angle, 0, 0])
    {
    for (i = [0 : len(pos)-1]) {

        if (i == 3)
        {
            translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
            UpperDINSupportChunk();
            
//            translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
//            PolycarbonateSupportPanel();
        }
    //    if (true)
    //    if (face_groups[i] != 3)
//        if (face_groups[i] == 0)
        if (i == 2)
    //    if (i == 0)
        {
        $fn=36*2;
        translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
        HolonomicMountPanel(panel=true);
    //    NeoCradlePanel();
        } else if (face_groups[i] != 3)
        {
    //    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    //    PolycarbonateSupportPanel();
        // Solid version...
        //TruncatedPlate(0.0, distances_from_corners = [pcorner_dist, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[0, 0, 0, 0, 0], mult = [1, 1, 1, 1, 1]);
        }
        }
    }
}



union()
{
    for (i = [0:2])
    {
        rotate([90, 0, 90+120*i]) 
        translate(rail_pos)
        union()
        {
        DIN_RailBoundingBox();
        DIN_RailLowerSlits();
        }
    }

    rotate([0, 0, 180])
    scale(10) import("penta_volume_bounds.stl");

    }

}

if (show_rails)
{

    for (i = [0:2])
    {
    rotate([90, 0, 90+120*i]) 
    translate(rail_pos)
    color([0.5, 0.5, 0.5, 1.0])
    TS35_DIN_Rail();
    }
}

// Upper Layer
//
//translate([0, 0, 135])
//for (i = [0:2])
//{
//rotate([90, 0, 30+120*i]) 
//translate(rail_pos)
//color([0.8, 0.8, 0.8, 1.0])
//TS35_DIN_Rail();
//}

}

LowerDINSupport();

//scale(10) import("penta_volume.stl");