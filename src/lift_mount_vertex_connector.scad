//include <vertex_connector.scad>
include <telescoping_lift.scad>
include <vertex_structure.scad>

module LiftMount()
{
union()
{
//scale(10) rotate([0, 0, 30]) 
    //FastPowerVert();

scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 30-180]) VertexConnectorRounded(height = (segment_len + MGN12[5])/10, rounding = 0.0, truncate=vertex_tehtra_height_truncation*2, prism_radius = 7);
 //scale(100) VertexConnector(power_variant=false);
//scale(10) rotate([0, 0, 30]) VertexConnectorV2();
translate([-28+10, 0, segment_len/2]) TelescopingLift();
//Stage1RopeAnchor();
}
}


//TelescopingLift();

//scale(10) translate([0, 0, dodecahedron_radius+vertex_tehtra_height_truncation]) rotate([0, 0, 90]) import("truncated_dodecahedroid.stl");
//rotate([0, 0, -90]) translate([0, 0, 0]) LiftMount();
//RailEndcapAnchor();
//Stage_1();

//difference()
//{
//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 30-180]) VertexConnectorRounded(height = (segment_len + MGN12[5])/10, rounding = 0.5, truncate=vertex_tehtra_height_truncation, prism_radius = 0);
//translate([-28+10, 0, segment_len/2]) StageOneVertexAnchor();
//}
//translate([-28+10, 0, segment_len/2]) TelescopingLift();
//Stage1RopeAnchor();


//difference()
//{
//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 30-180]) VertexConnectorRounded(height = (segment_len + MGN12[5])/10, rounding = 0.5, truncate=vertex_tehtra_height_truncation, prism_radius = 0);
//translate([-28+10, 0, segment_len/2]) StageOneVertexAnchor();
//}

lift_spawn_pos = [-28+10, 0, segment_len/2];
module IntegratedLift()
{

difference()
{
scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 30-180]) 
VertexStructure(height = (segment_len + MGN12[5])/10, rounding = 0.2, truncate=vertex_tehtra_height_truncation, prism_radius = 0.0, pent_h=5.75);
translate(lift_spawn_pos) StageOneVertexAnchor();
}
    difference()
    {
    translate(lift_spawn_pos) TelescopingLift();
    translate([0, 0, segment_len/4/2]) cube([100, 100, segment_len/4], center=true);
    }
}

IntegratedLift();