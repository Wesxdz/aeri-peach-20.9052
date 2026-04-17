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
VertexStructure(height = (segment_len + MGN12[5])/10, rounding = 0.2, truncate=vertex_tehtra_height_truncation, prism_radius = 0.0, pent_h=5.75, secure=1);
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
//translate(lift_spawn_pos) TelescopingLift();
//translate(lift_spawn_pos) Stage1RopeAnchor();
//translate([0, 0, segment_len/4/2]) cube([100, 100, segment_len/4], center=true); // cut off the 'rope anchor' bottom of the standard telescoping lift endcap anchor
}
}
}

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

attachment_height = 8.0; // TODO: Increase to 16
attachment_rad = 16;
module BaseMountAttachment()
{
scale(0.1)
{
IntegratedLift();

difference()
{
// Original attachment height was 8 but this was too small!

translate([0, 0, -attachment_height])
cylinder(attachment_height, attachment_rad, attachment_rad, $fn=36*3);

    union()
    {
    for (i = [0:3])
    {
    translate([0, 0, -attachment_height+2.5+1])
    rotate([0, 0, 30+120*i])
    rotate([90, 0, 0])
    translate([0, 0, attachment_rad-4])
    //translate([attachment_rad, 0, 0])
    union()
    {
    scale(10) BrassInsert();
    translate([0, 0, -6])
    cylinder(10, m3_rad, m3_rad);
    }
    }
}

}
}
}




//VertexStructure(secure=1);
//rotate([0, 180, 0])
//BaseMountAttachment();

module rounded_equilateral_triangle(side, radius) {
    // Standard height math
    h = side * sqrt(3) / 2;
    
    // To keep the 'side' length accurate, we move the centers
    // of the circles inward based on the radius.
    // However, for simple rounding, we can just hull circles:
    hull() {
        translate([-side/2, -h/3, 0]) circle(r=radius); // Bottom Left
        translate([side/2, -h/3, 0])  circle(r=radius); // Bottom Right
        translate([0, 2*h/3, 0])      circle(r=radius); // Top Apex
    }
}

module rounded_hexagon(side, radius) {
    // A regular hexagon's vertices are located at:
    // x = side * cos(angle)
    // y = side * sin(angle)
    // where angle = 0, 60, 120, 180, 240, 300 degrees.
    
    hull() {
        for (i = [0 : 5]) {
            angle = i * 60;
            translate([side * cos(angle), side * sin(angle), 0]) 
                circle(r = radius);
        }
    }
}


module CentralOmniballMountSupport()
{
taper_angle = 2;
delta_r = attachment_height * tan(taper_angle);
enter_rad = attachment_rad + delta_r;

$fn = 50;
support_mount_height = 41;
color([1, 0, 0, 1])
rotate([0, 0, -30])
difference()
{
difference()
{
linear_extrude(support_mount_height)
rounded_hexagon(side=enter_rad*2, radius=enter_rad);

cylinder(h=attachment_height, 
         r1=enter_rad, 
         r2=attachment_rad, 
         $fn=72);


}

translate([0, 0, attachment_height])
linear_extrude(support_mount_height)
rounded_hexagon(side=enter_rad*2-8, radius=enter_rad-2);
}
}

//rotate([0, 180, 0])
//CentralOmniballMountSupport();

//Stage1RopeAnchor();
//IntegratedLift();

// TOP Passthrough panel
//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 0]) 
//VertexStructure(height = 1.5, rounding = 0.1, truncate=vertex_tehtra_height_truncation*2, prism_radius = 3.5, pent_h=5.75);
//Stage1RopeAnchor();
//IntegratedLift();

//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 0]) 
//VertexStructure(height = 1.5, rounding = 0.1, truncate=vertex_tehtra_height_truncation*2, prism_radius = 3.5, pent_h=5.75);