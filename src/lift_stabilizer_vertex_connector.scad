// The Lift Stabilizer is a specialized vertex connector that is designed to provide an interface
// for securing the rail endcap top of the first MGN rail to the upmost vertex of the dodecahedron chassis

include <telescoping_lift.scad>
include <vertex_structure.scad>
include <vertex_composite.scad>
include <lift_mount_vertex_connector.scad>

//VertexStructure(height = 2.2, rounding = 0.2, truncate=vertex_tehtra_height_truncation*1.5, prism_radius = 4.3, pent_h=5.0, vertex_cut=1, secure=1);
//rotate([0, 0, 30]) import("lift_stabilizer.stl");
// Stage_1();
//IntegratedLift();
// translate(lift_spawn_pos) import("telescoping_lift.stl");


translate(lift_spawn_pos) 
{
    difference()
    {
    Stage_1Connect();
    union()
    {
    translate([0, 0, 10*(dodecahedron_radius+vertex_tehtra_height_truncation) + 168]) SecurePassthroughScrews();
    translate([0, 0, 10*(dodecahedron_radius+vertex_tehtra_height_truncation) + 183]) SecurePassthroughBrassInserts();
    }
    }
}
//IntegratedLift();


// What an ugly clusterfuck
// translate(lift_spawn_pos) 
// translate([0, 0, dodecahedron_radius*2*10-vertex_tehtra_height_truncation*1.0*10+0.6])
// translate([0, 0, 0]) rotate([0, 180, 180]) RailEndcapTopBlock();

//translate(lift_spawn_pos) SecurePassthroughScrews();
//translate(lift_spawn_pos) Stage_1Top();
//rotate([0, 0, 0]) RailEndcapTopBlock();

$fn=36;
module PassthroughConnector()

difference() {

    scale(10) 
    translate([0, 0, dodecahedron_radius+vertex_tehtra_height_truncation]) 
    rotate([0, 180, -30-180])
    VertexStructure(height = 2.2, rounding = 0.2, truncate=vertex_tehtra_height_truncation*1.5, prism_radius = 4.3, pent_h=5.0, vertex_cut=1, secure=1);

    // import("lift_stabilizer_vertex_connector_in_place.stl");
    translate([0, 0, 160]) translate(lift_spawn_pos) 
    {
        union()
        {
        SecurePassthroughScrews();
        translate([0, 0, 35]) SecurePassthroughScrewHeads();
        translate([0, 0, 35]) SecurePassthroughScrewHeadsUpper();
        }
    }
}



//translate([0, 0, dodecahedron_radius*10+(vertex_tehtra_height_truncation*10*0.5 + 1.75*10)]) PassthroughConnector();

//SecurePassthroughScrewHeadsUpper();


// scale(10) translate([0, 0, dodecahedron_radius+vertex_tehtra_height_truncation]) 
// {
//      PentaVolume();
// }





// scale(10) translate([0, 0, dodecahedron_radius+vertex_tehtra_height_truncation]) 
// {
//     PentaVolume();
// }