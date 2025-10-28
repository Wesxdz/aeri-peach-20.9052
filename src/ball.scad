include <hemisphere_transfer_unit.scad>
include <ball_bearings.scad>

module Hemisphere(radius, half_sep)
{
    $fn=128;
    difference()
    {
        color([0.0, 1.0, 0.5, 0.5])
        sphere(radius);
        translate([-radius, -half_sep, -radius]) cube([radius*2, radius*2, radius*2]);
    }
}

module SemiMount(thickness, width)
{
    $fn=36;
    linear_extrude(thickness) 
    hull()
    {
    circle(1.4);
    translate([0, width, 0])
    circle(1.4);
    }
}

module OmniBall(radius=4.0, separation=0.8)
{   
    //It neeHemisphereTransferUnit(radius, separation/2);
    union()
    {
    difference()
    {
    union()
    {
    
    //mirror([0, 1, 0]) HemisphereTransferUnit(radius, separation/2);
    mirror([0, 1, 0]) HemisphereDiff(radius, separation);
    }
    // Cut hole for middle bolt
//    $fn=36;
//    translate([0, radius+separation/2, 0])
//    rotate([90, 0, 0])
//    cylinder(radius*2+separation, .7, .7);
    }
    translate([0, -separation/2, 0]) BallBearing608();
    translate([0, separation/2+0.7, 0]) BallBearing608();
        
    bearing_edge = 0.5;
    // Central bolt
//    $fn=36;
//    translate([0, radius+separation/2-bearing_edge, 0])
//    rotate([90, 0, 0])
//    cylinder(radius*2+separation-bearing_edge*2, .4, .4);
    
    mount_spacing = 0.4;
    
    $fn=36;
    translate([-radius-mount_spacing, 0, 0])
    rotate([90, 0, 90])
    cylinder((radius+mount_spacing)*2, .4, .4);
    
    translate([-radius-mount_spacing-0.5, -1.4, radius+mount_spacing])
    cube([(radius+mount_spacing)*2+1, 2.8, .5]);
    
    translate([-radius-mount_spacing-0.5, 0, 0])
    union()
    {
    translate([0, -1.4, 0])
    cube([0.5, 2.8, radius+mount_spacing]);
    
    rotate([90, 0, 90]) SemiMount(0.5, 1.0);
    }
    
    mirror([1, 0, 0])
    translate([-radius-mount_spacing-0.5, 0, 0])
    union()
    {
    translate([0.0, -1.4, 0])
    cube([0.5, 2.8, radius+mount_spacing]);
    
    rotate([90, 0, 90]) SemiMount(0.5, 1.0);
    }
    
    }
}

OmniBall();