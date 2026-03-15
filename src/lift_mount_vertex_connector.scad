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
//Stage_1();\

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

mount_height = 8;
car_to_rail_top = (-MGN12H_carriage[4]+mount_height+8);
module LiftStageCutout()
{
    pad = 0.5;
    rope_pad = 4;
    rail_h = MGN12[2];
    translate([0, -rope_pad, 0])
    translate([-pad, -pad, -pad])
    translate([-rail_h / 2, -MGN12H_carriage[3] / 2, 0])
    cube([
        mount_height + 8 + car_to_rail_top + pad*2,
        my_carriage[3]*1.3 + pad*2 + 6 + rope_pad*2, 
        // MGN12H_carriage[3]+10, 
        segment_len + MGN12[5]-(segment_len/2) + pad*2
    ]);
}

module LiftStage2Cutout()
{
    rail_h = MGN12[2];
    pad = 0.5;
    rope_pad = 4;
    translate([0, -rope_pad, 0])
    translate([-pad, -pad, -pad])
    translate([-rail_h / 2, -MGN12H_carriage[3] / 2, 0])
    cube([
        mount_height + 8 + pad*2 + 4,
        my_carriage[3]*1.3 + pad*2 + rope_pad*2, 
        // MGN12H_carriage[3]+10, 
        segment_len + MGN12[5]-(segment_len/2) + pad*2
    ]);
}

lift_spawn_pos = [-28+8, 0, segment_len/2];
module IntegratedLift()
{

union()
{

difference()
{
scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 30-180]) 
VertexStructure(height = (segment_len + MGN12[5])/10, rounding = 0.2, truncate=vertex_tehtra_height_truncation, prism_radius = 0.0, pent_h=5.75);
translate(lift_spawn_pos) 
{
    // Backside cutout
    translate([-MGN12[2]*2, 0, 8]) RailEndcapAnchorBlock();
    translate([-MGN12[2]*4, 0, 8]) RailEndcapAnchorBlock();

    translate([MGN12[2]*2, 0, 0]) LiftStageCutout();
    translate([MGN12[2]*2 + mount_height + 8 + car_to_rail_top, 0, 4]) scale(1.01) mirror([0, 1, 0]) LiftStage2Cutout();
    RailEndcapAnchorBlock();
    RailEndcapRail();
}
// TODO: The critical part is we need to have a slot for an m3 screw
// to secure the rail to the vertex connector

StageOneVertexAnchor();
}

difference()
{
translate(lift_spawn_pos) TelescopingLift();
//translate(lift_spawn_pos) Stage1RopeAnchor();
translate([0, 0, segment_len/4/2]) cube([100, 100, segment_len/4], center=true); // cut off the 'rope anchor' bottom of the standard telescoping lift endcap anchor
}
}
}

//Stage1RopeAnchor();
//IntegratedLift();

//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 0]) 
//VertexStructure(height = 1.5, rounding = 0.1, truncate=vertex_tehtra_height_truncation*2, prism_radius = 3.5, pent_h=5.75);