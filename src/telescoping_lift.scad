include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rail.scad>

include <BOSL2/std.scad>
include <BOSL2/ball_bearings.scad>
include <BOSL2/screws.scad>
include <BOSL2/threading.scad>

module BrassInsert()
{
    $fn=64;
    cylinder(0.4, (0.5-0.02)/2, (0.5-0.02)/2);
}

//$fn=36*2;
$fn=16;

// TODO: Should carriage be facing 'backwards' to the previous stage or 'forwards' to hold the next stage?

module Torus(R=100, r=1) {
    rotate_extrude(convexity = 10)
        translate([R, 0, 0]) 
        circle(r);        
}

module UPulley()
{
    radius = 20;
    h = 7;
    difference()
    {
    cylinder(h, radius, radius);
    union()
    {
    translate([0, 0, h/2]) Torus(radius, 2);
    translate([0, 0, h/2]) Torus(radius-1, 2);
    translate([0, 0, h/2]) Torus(radius-2, 2);
    cylinder(h, 11, 11);
    }
    }
}

segment_len = 350/rail_holes(MGN12, 350);

//translate([4, (MGN12H_carriage[3]-MGN12[1])/2-1+7, 350-20])  rotate([0, 90, 90]) UPulley();

extended = 0.0;

my_rail = MGN12; 

my_carriage = MGN12H_carriage;

// 3. Define dimensions
rail_len = 350;
pos = 350/2 - MGN12H_carriage[1]/2 - segment_len*0.5-6;



module RoundTri(rad=1, corner_rad=1, height = 1)
{
    linear_extrude(height)
    {
    hull()
    {
    translate([sin(0)*rad, cos(0)*rad, 0]) circle(corner_rad);
    translate([sin(120)*rad, cos(120)*rad, 0]) circle(corner_rad);
    translate([sin(240)*rad, cos(240)*rad, 0]) circle(corner_rad);
    }
    }
}
//
//translate([20, 0, 0]) 
//scale(10)
//rotate([0, 0, -90])
//difference()
//{
//    RoundTri(3.5, 1, 100);
//    translate([0, 0, -0.05]) RoundTri(3.4, 0.7, 100.1);
//}

// TODO: Add the carriage/rail attachment holes
// TODO: Add a V grip to help secure the next rail... (difference scaled rail)
// TODO: Add a mechanism to mount rope anchor
// Should the mount that doesn't support the base of a rail be shorter? ie cap to 1 rail screw center
echo(segment_len);
m3_rad = 1.5+0.05;
module CarriageMount(carriage=my_carriage)
{
    c_width = carriage[2];
    mount_width = segment_len*3;
    c_len = carriage[3];
    s_spacing = carriage[6];
    mount_height = 8;
    
    difference()
    {
    
    union()
    {
    translate([-segment_len/2, -c_len*0.3, 0])
    cube([segment_len/2, c_len*1.3, mount_height + 8]); 
    
    difference()
    {
    union()
    {
    cube([mount_width , c_len, mount_height]);
    translate([0, -c_len*0.3, 0])
    cube([segment_len-1, c_len*1.3, mount_height + 8]); 
    }
    
    union()
    {
        translate([segment_len * 3/2 - s_spacing/2, 0, 0])
        union() {
            // Define the base offsets for the grid
            base_y = (c_len - s_spacing) / 2;

            for (x_offset = [0, s_spacing]) {
                for (y_offset = [0, s_spacing]) {
                    translate([x_offset, base_y + y_offset, 0]) {
                        // Main screw hole
                        cylinder(16, m3_rad, m3_rad);
                        
                        // Countersink / Nut trap (mirrored from mount_height)
                        translate([0, 0, mount_height]) 
                            mirror([0, 0, 1]) 
                            cylinder(3.0, 5.68/2, 5.68/2);
                    }
                }
            }
        }
    
        translate([0, c_len/2, 0])
        {
        linear_extrude(30)
        {
        rail_hole_positions(MGN12, 350)
        //circle(d = rail_hole(MGN12));
        circle(r = m3_rad);
        }
        rail_hole_positions(MGN12, 350)
        scale(1.01) nut_trap_inline(2.5, "M3");
        }
        }
        
        // TODO Nut catchments...
    }
    

    
    }
    color([1, 0, 0, 1])
    translate([0, c_len/2-MGN12[1]/2, MGN12[2]+mount_height])
    rotate([0, 90, 0])
    cube([MGN12[2]+0.1, MGN12[1]+0.1, 350]);

    // rope slot
    translate([-segment_len/4, c_len*1.5, (MGN12[2]+mount_height)/2])
    rotate([90, 0, 0])
    cylinder(c_len*3, 2, 2);
    
    }
}
//-my_carriage[2]-(my_carriage[1]-my_carriage[2])/2
//color([0.5, 0.5, 1.0, 0.7])
//rotate([0, 90, 0])
//translate([-segment_len*3, -my_carriage[3]/2, my_carriage[4]])

//mirror([0, 1, 0]) CarriageMount();


// 
// x2 anchor (needs to be combined with
// carriage mount piece...)
// x2 pulley mount

module RailEndcap()
{
rail_h = MGN12[2];
difference()
{
translate([-rail_h /2, -MGN12H_carriage[3]/2, -segment_len/4])
cube([rail_h *2, MGN12H_carriage[3], (segment_len*3/4)+MGN12[5]]);

union()
{
    translate([-0.05, -MGN12[1]/2-0.05, 0])
    cube([MGN12[2]+0.1, MGN12[1]+0.1, 350]);
    }

    translate([0, 0, segment_len/2])
    rotate([0, 90, 0])
    cylinder(MGN12[2]*2, MGN12[5]/2, MGN12[5]/2);
    
    translate([0, 0, segment_len/2])
    rotate([0, -90, 0])
    cylinder(MGN12[2]*2, m3_rad, m3_rad);
    
    translate([-2.5, 0, segment_len/2])
    rotate([0, -90, 0])
    scale([1.08, 1.04, 1.04])
    nut_trap_inline(2.5, "M3");
}
}


module RailEndcapAnchor()
{
rail_h = MGN12[2];
difference()
{

translate([-rail_h / 2, -MGN12H_carriage[3] / 2, -segment_len / 2])
    cube([
        rail_h * 2, 
        MGN12H_carriage[3], 
        segment_len + MGN12[5]
    ]);

    union()
    {
    translate([-0.05, -MGN12[1]/2-0.05, 0])
    cube([MGN12[2]+0.1, MGN12[1]+0.1, 350]);
    }

    translate([0, 0, segment_len/2])
    rotate([0, 90, 0])
    cylinder(MGN12[2]*2, MGN12[5]/2, MGN12[5]/2);
    
    translate([0, 0, segment_len/2])
    rotate([0, -90, 0])
    cylinder(MGN12[2]*2, m3_rad, m3_rad);
    
    translate([-2.5, 0, segment_len/2])
    rotate([0, -90, 0])
    scale([1.08, 1.04, 1.04])
    nut_trap_inline(2.5, "M3");
    
    // Rope slot
    translate([MGN12[2]/2, MGN12H_carriage[3]/2, -segment_len/4])
    rotate([90, 0, 0])
    cylinder(MGN12H_carriage[3], 2, 2);
}
}

//color([0.5, 0.5, 0.5, 0.5])
//RailEndcap();

// Uses m3 screws to prevent break...
module RailEndcapBackMount()
{
rail_h = MGN12[2];
difference()
{
translate([-rail_h /2-8, -MGN12H_carriage[3]/2, -segment_len/4])
cube([rail_h *2+8, MGN12H_carriage[3], (segment_len*3/4)+MGN12[5]]);

union()
{
    translate([-0.05, -MGN12[1]/2-0.05, 0])
    cube([MGN12[2]+0.1, MGN12[1]+0.1, 350]);
    }

    translate([0, 0, segment_len/2])
    rotate([0, 90, 0])
    cylinder(MGN12[2]*2, MGN12[5]/2, MGN12[5]/2);
    
    translate([0, 0, segment_len/2])
    rotate([0, -90, 0])
    cylinder(MGN12[2]*2, m3_rad, m3_rad);
    
    translate([-2.5-8, 0, segment_len/2])
    rotate([0, -90, 0])
    scale([1.08, 1.04, 1.04])
    nut_trap_inline(2.5, "M3");
}
}

//RailEndcapBackMount();

module RailEndcapTopMount()
{
rail_h = MGN12[2];
difference()
{
translate([-rail_h /2-8, -MGN12H_carriage[3]/2, -segment_len/4-8-2])
cube([rail_h *2+8, MGN12H_carriage[3], 2+8+(segment_len*3/4)+MGN12[5]]);

union()
{
    translate([-0.05, -MGN12[1]/2-0.05, 0])
    cube([MGN12[2]+0.1, MGN12[1]+0.1, 350]);
    }

    translate([0, 0, segment_len/2])
    rotate([0, 90, 0])
    cylinder(MGN12[2]*2, MGN12[5]/2, MGN12[5]/2);
    
    translate([0, 0, segment_len/2])
    rotate([0, -90, 0])
    cylinder(MGN12[2]*2, m3_rad, m3_rad);
    
    translate([-2.5-8, 0, segment_len/2])
    rotate([0, -90, 0])
    scale([1.08, 1.04, 1.04])
    nut_trap_inline(2.5, "M3");
    
    // 8mm rod slot
    translate([MGN12[2]+0.05-4-4, 30, -6])
    rotate([90, 0, 0])
    cylinder(100, 4, 4);
    
    translate([MGN12[2]+0.05-4-4, MGN12H_carriage[3]/2, -6])
    rotate([90, 30, 0])
    scale([1.04, 1.02, 1.02])
    nut_trap_inline(2.5, "M8");
}
}


function endcap_padding_bottom() = 10 + (segment_len / 4); // This is your z_lift
function endcap_extension_top()   = 10 + (MGN12[5] / 2 * 2); // Padding + rail hole dia

// Total Physical Height (What you asked for first)
function get_endcap_total_height() = 
    (segment_len * 0.75) + endcap_extension_top();

// Height minus the slot (The "Solid" base thickness)
function get_endcap_base_thickness() = 
    endcap_padding_bottom();


module RailEndcapSecondTopMount()
{
    rail_h = MGN12[2];
    rail_w = MGN12[1];
    c_len  = MGN12H_carriage[3];
    rail_hole_r = MGN12[5] / 2; 
    
    total_h = get_endcap_total_height();
    z_lift  = endcap_padding_bottom(); // This is the "base thickness" before the slot

    mirror([0, 1, 0])
    difference()
    {
        // 1. The Main Block
        translate([-rail_h / 2 - 7, -c_len / 2, 0])
            cube([rail_h + 15, c_len, total_h]);

        // 2. The Rail Slot (Starts after the base thickness)
        translate([-rail_h / 2 - 0.05, -rail_w / 2 - 0.05, z_lift])
            cube([rail_h + 0.1, rail_w + 0.1, rail_len]);

        // 3. Rail Mounting Holes
        translate([0, 0, segment_len / 2 + z_lift])
        union() {
            rotate([0, 90, 0]) cylinder(rail_h * 2, rail_hole_r, rail_hole_r);
            rotate([0, -90, 0]) cylinder(rail_h * 2, m3_rad, m3_rad);
            translate([-10.5, 0, 0])
                rotate([0, -90, 0])
                scale([1.08, 1.04, 1.04]) nut_trap_inline(2.5, "M3");
        }
        
        // 4. 8mm Rod Slot & Nut Trap
        translate([rail_h + 0.05 - 8, 30, -6 + z_lift])
            rotate([90, 0, 0]) cylinder(100, 4.1, 4.1);
        
        translate([rail_h + 0.05 - 8, c_len / 2, -6 + z_lift])
            rotate([90, 30, 0])
            scale([1.04, 1.02, 1.02]) nut_trap_inline(4.5, "M8");
    }
}


//translate([0, 0, 0])
//cube([MGN12[2], MGN12[1], 350]);

module Stage1RopeAnchor()
{
    difference()
    {
    color([0.5, 0.6, 0.7, 0.5]) RailEndcapAnchor();
    translate([MGN12[2]/2, 0, -segment_len/2]) scale(10) BrassInsert();
    translate([MGN12[2]/2, 0, -segment_len/2]) cylinder(5, m3_rad, m3_rad);
    }
}

// When the EndcapAnchor piece is integrated into the vertex connector
// it is necessary to pursue a distinct strategy for rope passthrough
module StageOneVertexAnchor()
{
    c_len  = MGN12H_carriage[3];
    rope_passthrough_radius = 2.3;
    // TODO: These holes should line up with the pulley centerline
    translate([MGN12[2]/2, c_len/2+rope_passthrough_radius, -segment_len/2]) cylinder(100, rope_passthrough_radius, rope_passthrough_radius);
    translate([MGN12[2]/2, -c_len/2-rope_passthrough_radius, -segment_len/2]) cylinder(100, rope_passthrough_radius, rope_passthrough_radius);
}

//color([0.5, 0.6, 0.7, 0.5]) RailEndcapSecondTopMount();

// TODO: If it causes friction with the bearing, cutout a ring on the top
// TODO: Probably 'enclose' the pulley at the top so it's just a passthrough directly on the ball bearing
// TODO: Make beefier design with ABS covering the bearing and m3 screws connecting the two sections
module PulleyFlangeHalf()
{
union()
{

translate([0, 0, 8])
difference()
{
cylinder(2.5, 11+5, 11+5);
cylinder(2.5, 11+0.5, 11+0.5);
}

//rotate([0, 180, 0])
difference()
{
cylinder(8, 11+5, 11+5);

union()
{
nut_trap_inline(6.5, "M8");
cylinder(10, 4, 4);
}
}

}
}

//PulleyFlangeHalf();


module PulleyHalf()
{
// 608 bearing
bearing_rad = 11.05;
bearing_height = 7;
//difference()
//{
//cylinder(bearing_height , bearing_rad , bearing_rad );
//cylinder(bearing_height , 4, 4);
//}


u_rad = 5;
space_rad = 6;
pulley_height = bearing_height+5*2;

difference()
{

difference()
{

total_rad = bearing_rad+u_rad+space_rad;
// half height because piece is symmetrical...
cylinder(pulley_height/2, total_rad+2, total_rad+2);

translate([0, 0, pulley_height/2])
Torus(total_rad, pulley_height/2-5);
}

union()
{
translate([0, 0, 5])
cylinder(pulley_height, bearing_rad, bearing_rad);
cylinder(pulley_height, bearing_rad-2, bearing_rad-2);
// TODO: Now place triangle of M3 cylinders and screw head cutout/nut cutout
for (i = [0:2])
{
    rotate([0, 0, 120*i]) 
    translate([0, bearing_rad + m3_rad*2, 0])
    union()
    {
        cylinder(pulley_height, m3_rad, m3_rad);
        //scale(1.01) nut_trap_inline(2.5, "M3");
        cylinder(3.0, 5.68/2, 5.68/2);
    }
}

}
}
}

//translate([0, 0, segment_len/2])
//rotate([0, -90, 0]) CarriageMount();
//import("vertical_carriage_mount.stl");

module Stage_1()
{
translate([0, 0, 350/2]) rotate([0, 90, 0])  rail_assembly(my_carriage, rail_len, pos);
Stage1RopeAnchor();
translate([0, 0, 350]) rotate([0, 180, 180]) RailEndcapTopMount();
color([1, 0.5, 0, 0.5]) translate([0, MGN12H_carriage[3]/1.5, 350+6]) rotate([-90, 0, 0]) UPulley();
}

module TelescopingLift()
{
Stage_1();
// my_carriage[1]-my_carriage[2] + 350/2+extended*(350/2*2-50)
color([0.4, 0.4, 0.5, 1.0])
translate([20-MGN12[2], MGN12H_carriage[3]/2, 0]) rotate([0, 0, 180]) import("vertical_carriage_mount.stl");
translate([20, 0, my_carriage[1]-my_carriage[2] + 350/2+extended*(350/2*2-50)]) rotate([0, 90, 0])  rail_assembly(my_carriage, rail_len, pos-my_carriage[1]);
// The second stage pulley is the major profile concern
color([1, 0, 0, 0.5]) translate([20, -MGN12H_carriage[3]/1.5, 350+16]) rotate([90, 0, 0]) UPulley();
translate([24, 0, get_endcap_base_thickness()+350+10]) rotate([0, 180, 0]) RailEndcapSecondTopMount();

// Just the rail w/o carriage on the final one!
color([0.6, 0.6, 0.7, 1.0])
translate([17*2-MGN12[2], -MGN12H_carriage[3]/2, 13]) rotate([0, 0, 180]) mirror([0, 1, 0]) import("vertical_carriage_mount.stl");
translate([17*2, 0, ((my_carriage[1]-my_carriage[2])*2) + 350/2+extended*(350/2*4-100)]) rotate([0, 90, 0])  rail_profile(carriage_rail(my_carriage), rail_len);
}

 //Stage1RopeAnchor();


// Specify endcap params
// Distance extending beyond rail end
// Distance 'below' rail
// Distance 'above' rail (often the same...)
// For the first stage, Below the rail, it's logical to add a 3mm diameter cylinder diff channel for the rope to pass through (and a front channel S on the side with tensioning screws to anchor second stage)
// Boolean include carriage cutouts
// Height in terms of either absolute size or 'number of rail screws' (to be parametric for different rail types)...

// What if we just start by testing the basic endcap functionality?

