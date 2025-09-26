// '608 Minimalist' by Wesley Spacebar

include <BOSL2/std.scad>
include <BOSL2/ball_bearings.scad>
include <BOSL2/screws.scad>
include <BOSL2/threading.scad>
// Use milimeters

//$fn=32;
// $fn=64;
// Production hemisphere
$fn=256;

// Radius of omniball
wheel_radius = 60;
// Radius of hemisphere connector cylinder
inner_radius = 40;
// The offset magnitude from the center of the sphere at which the
// barrel support cylinder begins
split_pos = wheel_radius/2+1;//5*3;
// The radius of the barrel support cylinder
wheel_cutout = 12.5;
// 608 bearing radius
bearing_cutout = 11+0.1; // 1mm for 3d printing errors 
// The distance from the perimeter of the barrel support cylinder hole
// to the nearby pole of the omniball cutoff
// ie the 'magnitude chopped off the poles'
chopped = calculate_chopped_distance(wheel_radius, wheel_cutout);
// 

// TODO: This was ordered as *9* for M3x15 + 3mm for cap, however, we need to use with M3x16 or
axis_connection_thickness = 9;

barrel_wheel_radius = 9;
barrel_wheel_offset = -wheel_radius + barrel_wheel_radius - chopped;
cuboid_fixed_cut = 20;
wheel_to_center_padding=1.0;
// (-50)
cuboid_offset = -wheel_radius + barrel_wheel_radius+wheel_to_center_padding;

// barrel_wheel_radius + wheel_to_center_padding should add to 10

barrel_slot_offset = (barrel_wheel_radius+wheel_to_center_padding)*2;

// The barrel wheel slot edge length should drive the other parameters
// because the rod needs to be a multiple of 10mm for purchase
//barrel_wheel_slot_edge = -barrel_wheel_offset - (barrel_wheel_radius+wheel_to_center_padding);

// 40
barrel_wheel_slot_edge = -cuboid_offset - cuboid_fixed_cut/2;

// The passive rod is 80mm
//barrel_wheel_slot_edge = 40; // wheel_radius - (barrel_wheel_radius+wheel_to_center_padding);

barrel_wheel_height = 13;

rod_pad = 10;

// There are two active 8mm rods, each with this height
active_rod_height=60;

// James Bruton's design used larger bearings like these
// https://www.amazon.com/uxcell-6705-2RS-Groove-Bearings-Double
// However the original Tetrahedral Mobile Robot (Tadakuma 2006) 
// from what I can tell used standard 608 bearings and expanded the inner cylinder
// Using standard 608 bearing
module BallBearing()
{
    difference()
    {
        cylinder(7, 22/2, 22/2);
        cylinder(7, 8/2, 8/2);
    }
}

module Semisphere()
{
    difference()
    {
        sphere(wheel_radius);
        translate([-axis_connection_thickness, -wheel_radius, -wheel_radius])
        cube([wheel_radius*2, wheel_radius*2, wheel_radius*2]);
    }
}

module SemisphereRing()
{
    difference()
    {
        sphere(wheel_radius);
        union()
        {
            // Remove the minimum region which the M8 rod must passthrough
            translate([-9/2, -wheel_radius, -wheel_radius])
            cube([wheel_radius*2, wheel_radius*2, wheel_radius*2]);
            
            // Remove the pole part of the hemisphere
            mirror([1, 0, 0]) translate([axis_connection_thickness+1.0, -wheel_radius, -wheel_radius])
            cube([wheel_radius*2, wheel_radius*2, wheel_radius*2]);
            
            // Remove the region which overlaps the axis connectors
            // large 6mm spacing region just in case
            rotate([0, -90, 0]) cylinder(h=10, r=inner_radius+6);
        }
    }
}

module HemisphereSection()
{
    difference()
    {
        Semisphere();
        wheel_padding = 1.0;
        union()
        {
        rotate([0, -90, 0]) cylinder(h=axis_connection_thickness+1, r1=wheel_radius, r2=wheel_radius); // cut out the whole first mm
        translate([-axis_connection_thickness-1, 0, 0]) rotate([0, -90, 0]) cylinder(h=7, r1=bearing_cutout, r2=bearing_cutout);
        // Place the bearings in from either side
        steel_ring_height = 1.0;
        translate([-axis_connection_thickness-1-7, 0, 0]) rotate([0, -90, 0]) cylinder(h=wheel_radius, r1=bearing_cutout-steel_ring_height, r2=bearing_cutout-steel_ring_height);
        translate([-split_pos+7, 0, 0]) rotate([0, -90, 0]) cylinder(h=7, r1=bearing_cutout, r2=bearing_cutout);
        
        // Barrel wheel support
        hull()
        {
        // this needs to remain open for insertion of wheel barrel support piece...
        translate([-split_pos, 0, 0]) rotate([0, -90, 0]) cylinder(h=wheel_radius-split_pos, r1=wheel_cutout+wheel_padding, r2=wheel_cutout+wheel_padding);
        }
        }
    }
}

module Bearings()
{       
        // Near-barrel wheel
        // The problem is that it will overlap the barrel dowel pin
        //translate([-wheel_radius + calculate_chopped_distance(wheel_radius, 37/2), 0, 0]) 
        translate([-split_pos, 0, 0]) rotate([0, 90, 0]) BallBearing();
        // Near axis-connector
        translate([-axis_connection_thickness -7-2, 0, 0]) rotate([0, 90, 0]) BallBearing();
}

function calculate_chopped_distance(sphere_radius, cylinder_radius) =
    (cylinder_radius >= sphere_radius) ? 0 : (sphere_radius - sqrt(pow(sphere_radius, 2) - pow(cylinder_radius, 2)));
    
module BarrelWheelSupportRodHalf()
{
    color([0.3, 0.3, 0.3])
    rotate([0, -90, 0]) 
    cylinder(h=barrel_wheel_slot_edge+0.001, r1=4, r2=4);
}

module BarrelWheelSupportRodThreaded()
{
    color([0.3, 0.3, 0.3])
    rotate([0, -90, 0])
    threaded_rod(d=8, height=barrel_wheel_slot_edge*2, pitch=1.25, $fa=1, $fs=1);
}

module BarrelWheelSupportRod()
{
    union()
    {
        BarrelWheelSupportRodHalf();
        mirror([1, 0, 0]) BarrelWheelSupportRodHalf();
    }
}

module HemisphereConnector(show_hemisphere_connector_section=true, show_barrel_region=true)
{   
    union()
    {
    difference()
    {
    union()
    {
        difference()
        {
        color([1.0, 0.5, 0.5, .4])
        union()
        {
        if (show_hemisphere_connector_section)
        {
        rotate([0, -90, 0]) cylinder(axis_connection_thickness , inner_radius , inner_radius);
        // Bearing spacer
        translate([-axis_connection_thickness -2, 0, 0])    
        rotate([0, 90, 0]) cylinder(2, 22/2, 22/2);
        }
        }
        //  hole
        BarrelWheelSupportRodHalf();
        }
        
        if (show_barrel_region)
        {
        difference()
        {
            color([0.3, 0.9, 0.4, 0.5])
            hull()
            {
            // Barrel wheel support narrowing edge
            translate([-split_pos, 0, 0]) rotate([0, -90, 0]) cylinder(h=(wheel_radius-split_pos), r1=barrel_wheel_height/2, r2=barrel_wheel_height/2);
            
            translate([-split_pos, 0, 0]) rotate([0, -90, 0]) cylinder(h=(wheel_radius-split_pos)-4, r1=wheel_cutout, r2=wheel_cutout);
            }
            
            union()
            {
                //translate([barrel_wheel_offset, 0, 0])    cuboid([barrel_slot_offset, 40, barrel_wheel_height], rounding=0.5);
                barrel_wheel_vertical_padding = 0.5;
                translate([cuboid_offset, 0, 0]) cuboid([cuboid_fixed_cut, 40, barrel_wheel_height+barrel_wheel_vertical_padding ], rounding=0.5);
                // fully cut off the tip of the support region
                translate([cuboid_offset-5, 0, 0]) cuboid([cuboid_fixed_cut, 40, barrel_wheel_height+barrel_wheel_vertical_padding], rounding=0.5);
                
                for (i = [0:1])
                {   
                    translate(nut_pos[i])
                    rotate(nut_rot[i]) rotate([0, 0, 30]) scale(1.1) nut_trap_inline(6.5, "M8");
                }
                
                BarrelWheelSupportRod();
                
            }
        }
        }
        
        
        // color([0.3, 0.3, 0.3, 1]) Bearings();
    }
    // dowel pin hole
    translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(wheel_cutout*2, 1.5, 1.5);
    }
    //color([0.9, 0.9, 0.9])
    //translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(wheel_cutout*2, 1.5, 1.5);
    }
}

module BarrelWheel(radius=barrel_wheel_radius, height=barrel_wheel_height)
{
    difference()
    {
    hull()
    {
        translate([0,0,-height/2]) cylinder(0.1, radius-radius/8);
        translate([0,0,-height/2+height/16]) cylinder(0.1, radius-radius/16);
        translate([0,0,-height/2+height/4]) cylinder(0.1, radius);
        translate([0,0,height/2-height/4]) cylinder(0.1, radius);
        translate([0,0,height/2-height/16]) cylinder(0.1, radius-radius/16);
        translate([0,0,height/2]) cylinder(0.1, radius-radius/8);
    }
    translate([0, 0, -wheel_cutout]) cylinder(30, 1.5, 1.5);
    }
}

module SemiWrap()
{
    HemisphereSection();
    SemisphereRing();
}

module BarrelWheelPlacement()
{
    translate([barrel_wheel_offset, 0, 0]) 
    {
        BarrelWheel();
    }
}

module Semiball()
{

    union()
    {
    difference()
    {
    HemisphereConnector();
    }
    translate([barrel_wheel_offset, 0, 0]) 
    {
        BarrelWheel();
        // https://www.aliexpress.us/item/2255800287548941.html
        // Use 'dowel pin'
        //translate([0, 0, -wheel_cutout]) cylinder(30, 1.5, 1.5);
        
    }
    }
}

module ActiveRods()
{
    // 60mm m8 threaded rods for active axis
    color([0.5, 0.5, 0.5]) translate([0, wheel_radius+rod_pad, 0]) rotate([90, 0, 0]) cylinder((active_rod_height), 4, 4);
    
    color([0.5, 0.5, 0.5]) translate([0, -wheel_radius-rod_pad, 0]) rotate([-90, 0, 0]) cylinder((active_rod_height), 4, 4);
}

module ActiveRodsThreaded()
{
    // 60mm m8 threaded rods for active axis
    color([0.5, 0.5, 0.5]) translate([0, wheel_radius+rod_pad-active_rod_height/2, 0]) rotate([90, 0, 0]) threaded_rod(d=8, height=active_rod_height, pitch=1.25, $fa=1, $fs=1);
    
    color([0.5, 0.5, 0.5]) translate([0, -wheel_radius-rod_pad+
    active_rod_height/2, 0]) rotate([-90, 0, 0]) threaded_rod(d=8, height=active_rod_height, pitch=1.25, $fa=1, $fs=1);
}

nut_pos = [[-barrel_wheel_slot_edge-0.001, 0, 0], [barrel_wheel_slot_edge-6.5-0.001, 0, 0], [-3.25, 0, 0], [0, wheel_radius+rod_pad-active_rod_height+6.5, 0], [0, -wheel_radius-rod_pad+active_rod_height, 0]];

nut_rot = [[0, 90, 0], [0, 90, 0], [0, 90, 0], [90, 0, 0], [90, 0, 0]];

module OmniballNuts()
{
    for (i = [0:4])
    {   
        color([0.8, 0.8, 0.9])
        translate(nut_pos[i])
        rotate(nut_rot[i]) rotate([0, 0, 30]) nut("M8");
    }
}

module Omniball(show_rod=false, show_nuts=false, show_screws=false)
{
    union()
    {
        difference()
        {
            union()
            {
                difference()
                {
                    union()
                    {
                        Semiball();
                        
                        //HemisphereConnector();
                        if (show_nuts)
                        {
                            OmmniballNuts();
                        }

                        mirror([1, 0, 0]) Semiball();
                        //mirror([1, 0, 0]) HemisphereConnector();
                    }
                    union()
                    {   
                        AxisConnectionScrews();
                        AxisConnectionScrewHeadCuts();
                        AxisConnectionScrewNutCuts();
                    }
                }
                if (show_nuts)
                {
                    AxisConnectionScrewNuts();
                }
                if (show_rod)
                {
                    ActiveRods();
                }
            }
            
            union()
            {
                // hole
                ActiveRods();
                for (i = [2:4])
                {
                    
                    translate(nut_pos[i])
                    rotate(nut_rot[i]) rotate([0, 0, 30]) scale(1.1) nut_trap_inline(6.5, "M8");
                }
                
                AxisConnectionScrews();
                // Nut trap inside two hemisphere connections
                // to connect barrel wheel support axis
            }
        }
        // hole
        if (show_screws)
        {
            AxisConnectionScrews();
        }
        }
        
        if (show_rod)
        {
        color([0.5, 0.5, 0.5])
        union() {
        BarrelWheelSupportRod();
        }
    }
}

module Omniwrap()
{
    SemiWrap();
    mirror([1, 0, 0]) SemiWrap();
}

module AxisConnectionScrews()
{
    axis_connector_screws = 8;
    for (i=[0:(axis_connector_screws-1)])
    {
        if (i != 2 && i != 6)
        {
        translate([7.5+1.5-axis_connection_thickness, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) screw_hole("M3", head="socket", thread="none", length=15, oversize=0.15);
        }
    }
}

module AxisConnectionScrewHeadCuts()
{
    axis_connector_screws = 8;
    for (i=[0:(axis_connector_screws-1)])
    {
        if (i != 2 && i != 6)
        {
        translate([-axis_connection_thickness+3-0.001, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) cylinder(3.0, 5.68/2, 5.68/2);
        }
    }
}

module AxisConnectionScrewNutCuts()
{
    axis_connector_screws = 8;
    for (i=[0:(axis_connector_screws-1)])
    {
        if (i != 2 && i != 6)
        {
        translate([axis_connection_thickness, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) scale(1.1) nut_trap_inline(3, "M3");
        }
    }
}

module AxisConnectionScrewNuts()
{
    axis_connector_screws = 8;
    for (i=[0:(axis_connector_screws-1)])
    {
        if (i != 2 && i != 6)
        {
        translate([axis_connection_thickness, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) nut("M3");
        }
    }
}

module CrossSection()
{
difference()
{
union()
{
Omniball(true, true, true);
color([0, 0.5, 0.5, 0.2])
Omniwrap();
}
//translate([-100, 0, -100]) cube([200, 200, 200]);
}
}

CrossSection();



module Hemispheres()
{
HemisphereConnector();
mirror([1, 0, 0]) HemisphereConnector();
}

module RodSystem()
{
BarrelWheelSupportRodThreaded();
ActiveRodsThreaded();
}

// 3D print part renders
// BarrelWheel(); // x2

// BarrelWheelSupport x2
// translate([0, 0, -split_pos]) rotate([0, 90, 0]) HemisphereConnector(show_hemisphere_connector_section=false);

module ConnectorCutout()
{
    union()
    {
        AxisConnectionScrews();
        AxisConnectionScrewHeadCuts();
        AxisConnectionScrewNutCuts();
        
        ActiveRods();
        for (i = [2:4])
        {
            
            translate(nut_pos[i])
            rotate(nut_rot[i]) rotate([0, 0, 30]) scale(1.1) nut_trap_inline(6.5, "M8");
        }
    }
}

module RightHemisphereConnector()
{
    rotate([0, 90, 0])
    difference()
    {
        HemisphereConnector(show_barrel_region=false);
        ConnectorCutout();
    }
}
// RightHemisphereConnector();

module LeftHemisphereConnector()
{   
    rotate([0, -90, 0])
    difference()
    {
        mirror([1, 0, 0]) HemisphereConnector(show_barrel_region=false);
        ConnectorCutout();
    }
}
// LeftHemisphereConnector();

//rotate([0, 90, 0]) SemiWrap();
