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

// attachment_height = 8.0;
attachment_height = 8.0; // TODO: Increase to 16
neo_hook = 16;
// attachment_rad = 16+4;
attachment_rad = 16;
module BaseMountAttachment()
{
scale(0.1)
{
IntegratedLift();

difference()
{
// Original attachment height was 8 but this was too small!

translate([0, 0, -neo_hook])
cylinder(neo_hook, attachment_rad, attachment_rad, $fn=36*3);

    union()
    {
    for (i = [0:2])
    {
    translate([0, 0, -neo_hook+2.5+1])
    rotate([0, 0, 120*i-30])
    rotate([90, 0, 0])
    translate([0, 0, attachment_rad-4])
    //translate([attachment_rad, 0, 0])
    union()
    {
    scale(10) BrassInsert();
    translate([0, 0, -6])
    cylinder(10, m3_rad*10, m3_rad*10, $fn=36);
    }
    }
}

}
}
}

module rounded_hexagon(side, radius) {    
    hull() {
        for (i = [0 : 5]) {
            angle = i * 60;
            translate([side * cos(angle), side * sin(angle), 0]) 
                circle(r = radius);
        }
    }
}


module CentralOmniballMountSupport(bearing_z=0)
{
taper_angle = 2;
delta_r = attachment_height * tan(taper_angle);
enter_rad = attachment_rad + delta_r;

$fn = 50;
support_mount_height = 46;

difference() {
    
rotate([0, 0, -30])
difference()
{

union()
{
    
    difference() {
        
    linear_extrude(support_mount_height)
    rounded_hexagon(side=enter_rad*2, radius=enter_rad);
    
    translate([0, 0, attachment_height])
    linear_extrude(support_mount_height)
    rounded_hexagon(side=enter_rad*2-8, radius=enter_rad-2);

    }

// wall for attaching to vertex connector/lift mount
cylinder(h=attachment_height+8, 
         r1=enter_rad+4, 
         r2=attachment_rad+4, 
         $fn=72);

}


    union()
    {
        cylinder(h=attachment_height+8, 
                r1=enter_rad, 
                r2=attachment_rad, 
                $fn=72);

        }

        // 608 bearing cutouts
        // for (i = [0:2])
        // {
        //     bearing_cutout = 11;
        //     rotate([0, 0, 120*i+60])
        //     translate([0, enter_rad*2+5, bearing_cutout+bearing_z])
        //     rotate([-90, 0, 0])
        //     color([0, 0, 1, 1])
        //     cylinder(h=7, r1=bearing_cutout, r2=bearing_cutout);
        // }

        for (i = [0:2])
        {
            bearing_cutout = 11.05;
            rotate([0, 0, 120*i])
            translate([0, enter_rad*2, bearing_cutout+attachment_height])
            rotate([-90, 0, 0])
            cylinder(h=20, r1=bearing_cutout, r2=bearing_cutout);
        }

        for (i = [0:2])
        {
            rotate([0, 0, 120*i])
            translate([0, 0, m3_rad*10+attachment_height+1])
            rotate([-90, 0, 0])
            cylinder(h=100, r1=m3_rad*10, r2=m3_rad*10);
        }

    }

}
}
//translate([0, 0, -0.1]) rotate([0, 180, 0]) scale(0.1) CentralOmniballMountSupport();

//CentralOmniballMountSupport();
//rotate([0, 180, 0])
//scale(10)
//BaseMountAttachment();


//Stage1RopeAnchor();
//IntegratedLift();

// TOP Passthrough panel
//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 0]) 
//VertexStructure(height = 1.5, rounding = 0.1, truncate=vertex_tehtra_height_truncation*2, prism_radius = 3.5, pent_h=5.75);
//Stage1RopeAnchor();
//IntegratedLift();
//scale(10) BaseMountAttachment();
//rotate([0, 180, 0])
//CentralOmniballMountSupport();

//scale(10) translate([0, 0, -vertex_tehtra_height_truncation]) rotate([0, 0, 0]) 
//VertexStructure(height = 1.5, rounding = 0.1, truncate=vertex_tehtra_height_truncation*2, prism_radius = 3.5, pent_h=5.75);