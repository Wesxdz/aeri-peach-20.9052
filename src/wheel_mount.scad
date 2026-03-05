include <nutsnbolts/cyl_head_bolt.scad>;
include <dodecahedroid_config.scad>
include <gt2_20_pulley.scad>
include <ball_bearings.scad>
include <belt_len.scad>
include <wheel_shield.scad>

// Mounting bracket for wheels

module beveled_cylinder(h, r) {
    $fn = 64; // Optional: set the number of fragments for a smoother shape
    minkowski() {
        translate([0, 0, 0.5]) cylinder(h - 1.0, r - 0.5, r - 0.5); // Adjusted cylinder dimensions
        sphere(0.5); // Bevel radius
    }
}

module OmniBall(radius)
{
   sphere(radius);
}

// https://www.pololu.com/product/3278
// 100x24mm (with 608 bearing)
module ScooterWheel(radius)
{
    difference()
    {
    union()
    {
    difference()
    {
        hull()
        {
            cylinder(2.4, radius*0.5, radius*0.5);
            translate([0, 0, 0.6]) beveled_cylinder(1.2, radius);
        }
        $fn = 32;
        cylinder(2.4, 1.1, 1.1);
    }
    $fn = 32;
    translate([0, 0, 2.4-0.7]) cylinder(0.7, 1.1, 1.1);
    cylinder(0.7, 1.1, 1.1);
    //translate([0, 0, -.51]) cylinder(1.5, .5, .5); // Builtin spacer
    }
    $fn = 32;
    cylinder(2.4, .3, .3);
    }
}

module ScooterWheelCutout(radius)
{
    union()
    {
    union()
    {
        hull()
        {
            cylinder(2.4, radius*0.5, radius*0.5);
            translate([0, 0, 0.0]) beveled_cylinder(2.4, radius);
        }
        $fn = 32;
        cylinder(2.4, 1.1, 1.1);
    }
    }
}

//module Trapezoid(lower_width, upper_width, height)
//{
//    union()
//    {
//    polygon([[0, 0], [upper_width, 0], [lower_width, height], [0, height]]);
//    mirror([1, 0, 0]) polygon([[0, 0], [upper_width, 0], [lower_width, height], [0, height]]);
//    }
//}

// Rounded hull trapezoid
module Trapezoid(lower_width, upper_width, height, cylinder_radius=0.5) {
    $fn=100;
    union() {
        // Define the corners of the trapezoid
        corner1 = [0, 0];
        corner2 = [upper_width, 0];
        corner3 = [lower_width, height];
        corner4 = [0, height];

        // Create the hull
        hull() {
            translate([corner1[0], corner1[1], 0]) circle(r=cylinder_radius);
            translate([corner2[0], corner2[1], 0]) circle(r=cylinder_radius);
            translate([corner3[0], corner3[1], 0]) circle(r=cylinder_radius);
            translate([corner4[0], corner4[1], 0]) circle(r=cylinder_radius);
        }
    }
}

module TSlotCornerBracket()
{
difference()
{
cube([2, 2.8, 2.8]);
translate([0, 0, .4]) cube([2, 2.4, 2.4]);
$fn = 32;
// Bottom cutout
translate([1, 2.8/2, 0]) hull()
{
translate([0, -0.7, 0]) cylinder(1, .3, .3);
translate([0, 0.2, 0]) cylinder(1, .3, .3);
}
// Top cutout
translate([1, 2.8, 1.4]) rotate([90, 0, 0]) hull()
{
translate([0, -0.2, 0]) cylinder(1, .3, .3);
translate([0, 0.7, 0]) cylinder(1, .3, .3);
}
}
}

module MountBrackets()
{
    // Wheel side angle brackets
    //translate([-1, -2.8, .1]) TSlotCornerBracket();
    // translate([1, -2.8, .1]) TSlotCornerBracket();
    // mirror([1, 0, 0]) translate([1, -2.8, .1]) TSlotCornerBracket();
    // Back angle bracket
    mirror([1, 0, 0])  mirror([0, 0, 1]) translate([1, -2.8-.5-panel_thickness, 0]) TSlotCornerBracket();
    mirror([0, 0, 1]) translate([1, -2.8-.5-panel_thickness, 0]) TSlotCornerBracket();
    //mirror([0, 0, 1]) translate([-1, -2.8, 0]) TSlotCornerBracket();
}
// at 6.5, then it is not flat
gearmotor_dshaft_mount_cylinder_radius = 0.6;
panel_overhang = 1.38;
back_panel_to_wheel_center = gearmotor_dshaft_mount_cylinder_radius + (C - panel_thickness - panel_overhang);
front_panel_to_wheel_center = back_panel_to_wheel_center + 0.75;
module SupportPlane(depth, wheel_config=2, t_slots=false, panel_to_wheel_center=back_panel_to_wheel_center, axis_radius=0.3)
{

    perp_insert_form = 
    [
        [insert_width+bracket_start, 0],
        [insert_width+bracket_start, -panel_thickness],
        [bracket_width+bracket_start, -bracket_height-panel_thickness],
        [bracket_start, -bracket_height-panel_thickness],
        [bracket_start, 0],
        [insert_width+bracket_start, 0],
    ];
    difference()
    {
        union()
        {
        
        difference()
        {
        union()
        {
        far_extend = 5.3;
        short_extend = 5.3; //4
        if (wheel_config == 1)
        {
            linear_extrude(depth) Trapezoid(1, far_extend, panel_to_wheel_center);
            mirror([1, 0, 0]) linear_extrude(depth) Trapezoid(1, far_extend, panel_to_wheel_center);
        }
        if (wheel_config == 2)
        { 
            linear_extrude(depth) Trapezoid(1, far_extend, panel_to_wheel_center);
            mirror([1, 0, 0]) linear_extrude(depth) Trapezoid(1, short_extend, panel_to_wheel_center);
        }
        if (wheel_config == 3)
        { 
            linear_extrude(depth) Trapezoid(1, short_extend, panel_to_wheel_center);
            mirror([1, 0, 0]) linear_extrude(depth) Trapezoid(1, far_extend, panel_to_wheel_center);
        }
        }
        translate([-12, -0.6, 0.0]) cube([24, 1-0.4, depth]); // Flat intersection
        }
        {
        difference()
        {
            linear_extrude(depth) polygon(perp_insert_form);
            if (t_slots)
            {
            translate([bracket_start+1-0.3, -bracket_height-panel_thickness-0.001, depth-t_slot_cut_depth]) cube([0.6, bracket_height+panel_thickness+0.001, t_slot_cut_depth]);
            }
            $fn = 32;
            translate([bracket_start+1, -bracket_height/2-panel_thickness, 1]) 
            {
            scale(0.1) screw("M6x16");

            }
        }
        
        mirror([1, 0, 0]) difference()
        {
            linear_extrude(depth) polygon(perp_insert_form);
            $fn = 32;
            if (t_slots)
            {
            translate([bracket_start+1-0.3, -bracket_height-panel_thickness-0.001, depth-t_slot_cut_depth]) cube([0.6, bracket_height+panel_thickness+0.001, t_slot_cut_depth]);
            }
            translate([bracket_start+1, -bracket_height/2-panel_thickness, 1]) scale(.1) screw("M6x16");
        }
        
        }
        }
        
        union()
        {
            translate([0, 3, 0]) 
            {
                hull()
                {
                    if (wheel_config == 2)
                    {
                    translate([1.0, 0, 0]) cylinder(5, 0.25, 0.25); // M5
                    translate([-1.5, 0, 0]) cylinder(5, 0.25, 0.25);
                    
                    } else if (wheel_config == 3)
                    {
                    translate([1.5, 0, 0]) cylinder(5, 0.25, 0.25); // M5
                    translate([-1.0, 0, 0]) cylinder(5, 0.25, 0.25);
                    }
                }
            }
            $fn = 32;
            // 6mm
            // TODO: Replace with 608 bearing
            if (axis_radius == 0.3)
            {
                translate([0, panel_to_wheel_center-1, 0.0]) BallBearing626Cutout();
            } else
            {
                translate([0, panel_to_wheel_center-1, 0.0]) BallBearing608Cutout();
            }
            translate([0, panel_to_wheel_center-1, 0]) cylinder(4, axis_radius, axis_radius);
        }
    }
}

module WheelShaft(shield_overlay, cut_d)
{
    $fn=36;
    translate([0, 0, -2.5]) 
    difference()
    {   
        if (shield_overlay)
        {
            cylinder(6.0, 0.3, 0.3); // Longer D shaft to span to other 626
        } else
        {
            cylinder(4.0, 0.3, 0.3);
        }
        if (cut_d)
        {
            translate([0.55, 0, 0]) cube([0.6, 0.6, 10.0], true);
        }
    }
}

module MountedWheel(depth=0.5, wheel_config=2)
{
    shield_overlay = false;
    
    mirror([0, 0, 1]) color([1.0, 0.0, 1.0, 1.0]) translate([0, -2.5, 0.7]) GT2_20_IdlePulley();
    
    mirror([0, 0, 1]) color([1.0, 0.0, 1.0, 1.0]) translate([0, 0, 0]) GT2_20_Pulley();
    
    rotate([-90, 0, 0]) BallBearing626();
    
    spacer_depth = 0.51;
    translate([0, 0, spacer_depth+depth])
    {
    // BOM 6mm D-shaft
    color([1.0, 0, 0, 1]) 
    WheelShaft(shield_overlay, true);

    //scale(0.1) screw("M6x45");
    
    // TODO: This uses the Pololu conversion kit now...
    //translate([0, 0, -.7-depth]) scale(0.1) nut("M8");  
    // Small wheel
    // translate([0, 0, .51+.1]) ScooterWheel(3.6);
    // Large wheel
    // 608 bearing builtin spacer
    translate([0, 0, -0.4]) ScooterWheel(5.0);
    color([1, 1, 1]) translate([0, -panel_to_wheel_center+1, -depth-spacer_depth]) SupportPlane(depth, wheel_config, true);
    }
    
    
    if (shield_overlay)
    {
    difference()
    {
    union()
    {
    intersection()
    {
    translate([-8, -panel_to_wheel_center+1, 0]) cube([16, 3, 3.7]);
    translate([0, -panel_to_wheel_center+1, -depth-spacer_depth]) SupportPlane(10, wheel_config, false);
    }
        difference()
        {
        scale([1, 1, 1]) translate([-2.5, 3.3, 4.3]) rotate([0, 180, 180]) ShieldBrace();
        union()
        {
        translate([-8, -panel_to_wheel_center-4, 0]) cube([16, 5, 10]);
        }
        }
    }
    translate([0, -1.5, 0.8]) panel_to_wheel_centerscale(1.0) ScooterWheelCutout(5.0);
    WheelShaft(shield_overlay, false);
    }
    }


}

module MountedOmniBall(depth=0.5, panel_to_wheel_center)
{
    spacer_depth = 0.51;
    translate([0, 0, depth+2.4-depth]) scale(0.1) screw("M8x45");
    translate([0, 0, -.7-depth]) scale(0.1) nut("M8");  
    // Small wheel
    // translate([0, 0, .51+.1]) ScooterWheel(3.6);
    // Large wheel
    // 608 bearing builtin spacer
    //translate([0, 0, -spacer_depth+depth]) OmniBall(6.5);
    translate([0, 0, -spacer_depth+depth]) rotate([0, 0, 90]) scale(0.1) import("omniball.stl");
    
    translate([7, -panel_to_wheel_center+1, 0]) rotate([0, 90, 0]) translate([0, 0, -depth/2])SupportPlane(depth, 1, false, front_panel_to_wheel_center, 0.4);
    
    translate([-7, -panel_to_wheel_center+1, 0]) rotate([0, 90, 0]) translate([0, 0, -depth/2]) SupportPlane(depth, 1, false, front_panel_to_wheel_center, 0.4);
}

//MountedOmniBall(mounted_wheel_depth);

//MountedWheel(mounted_wheel_depth);
//SupportPlane(mounted_wheel_depth, 2);
// MountedOmniBall

//SupportPlane(mounted_wheel_depth, 3, true);
//SupportPlane(mounted_wheel_depth, 1, false, front_panel_to_wheel_center, 0.4);

//MountedOmniBall(mounted_wheel_depth, front_panel_to_wheel_center);