// '6808 Alderbaran Corpse Loot' by Wesley Spacebar

module BrassInsert()
{
    $fn=64;
    cylinder(4, (5-0.2)/2, (5-0.2)/2);
}

include <BOSL2/std.scad>
include <BOSL2/ball_bearings.scad>
include <BOSL2/screws.scad>
include <BOSL2/threading.scad>

// There is an include conflict with BOSL2
include <nutsnbolts/cyl_head_bolt.scad>;
// Use milimeters 

//$fn=16;
//$fn=32;
$fn=64*8;
// Production hemisphere
//$fn=16;


// in mm
omniball_radius = 60;

// Radius of hemisphere connector cylinder
inner_radius = (omniball_radius*2)/3;

// The offset magnitude from the center of the sphere at which the
// barrel support cylinder begins
// TODO: VAR

// 6808 bearing
bearing_height = 7;
bearing_inner_radius = 40/2;
bearing_outer_radius = 52/2;

// The radius of the barrel wheel support cylinder (rests on inner radius of bearings)
wheel_cutout = bearing_outer_radius-2;

bearing_cutout = bearing_outer_radius+0.1; // 1mm for 3d printing errors

// The distance from the perimeter of the barrel support cylinder hole
// to the nearby pole of the omniball cutoff
// ie the 'magnitude chopped off the poles'
//chopped = calculate_chopped_distance(omniball_radius, wheel_cutout);
// 

// TODO: This was ordered as *9* for M3x15 + 3mm for cap, however, we need to use with M3x16 or
axis_connection_thickness = 9;

// Pepper style
// bearing_outer_radius*2-0.3;
//barrel_wheel_height = 28-0.3; // plenty of spacing!
drop_second_bearing = 25;
//barrel_wheel_height = 36-0.3; // plenty of spacing!
barrel_wheel_height = 38-0.3; // plenty of spacing!
// TODO: This radius may need to be increased so that the barrel platform
// has a sufficient strength clamp
barrel_omniball_radius = 14;//18;
barrel_wheel_offset = -omniball_radius + barrel_omniball_radius;
cuboid_fixed_cut = 20;
wheel_to_center_padding=1.0;
// (-50)
// barrel_omniball_radius
cuboid_offset = -omniball_radius + 9 + wheel_to_center_padding;

// barrel_omniball_radius + wheel_to_center_padding should add to 10

barrel_slot_offset = (barrel_omniball_radius+wheel_to_center_padding)*2;

// 40
// barrel_wheel_slot_edge = -cuboid_offset - cuboid_fixed_cut/2;
barrel_wheel_slot_edge = 80/2;

// 1mm can sometimes be too small and TPU compression at the edges of the wheel
// cause the hemisphere to collide with the connector
// This may be less of an issue if TPU is printed above a harder material in a multi material system

// Keep this value under 6 or there will not be a spacer betwen the bearings!
hemisphere_connector_spacer_height = 2;


//barrel_wheel_slot_edge = 40; // omniball_radius - (barrel_omniball_radius+wheel_to_center_padding);



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
// 6808-2RS
module BallBearing6808()
{  
    ir = 40/2;
    or = 52/2;
    h = 7;
    difference()
    {
        cylinder(h, or, or);
        cylinder(h, ir, ir);
    }
}

module NeoBearings()
{
translate([0, 0, axis_connection_thickness+hemisphere_connector_spacer_height])
color([1, 0.7, 0])
BallBearing6808();

translate([0, 0, omniball_radius-bearing_height-drop_second_bearing])
color([1, 0.7, 0])
BallBearing6808();
}


module BarrelRodEntryVolume(rad_mult = 0.5)
{
    support_rod_overhang = 6;
    wheel_curve_offset = -omniball_radius + barrel_omniball_radius*rad_mult;
    rotate([0, 90, 0])
    translate([wheel_curve_offset+barrel_omniball_radius*0.5, 0, 0])
    {
    color([0.5, 0.5, 0.5, 1.0])
    // m4 button screw radius
    translate([0, 0, -bearing_outer_radius+(45-5.2-barrel_wheel_height)/2]) 
    {
        union()
        {
        // M6x45 + head
        cylinder(45+5.2, 3.06, 3.06);
        translate([0, 0, 5.2+1]) nut("M6");
        translate([0, 0, 5.2+45-1]) nut("M6");
        }
    }
    }
}

platform_height = (omniball_radius-barrel_omniball_radius)-(omniball_radius-bearing_height-drop_second_bearing)-bearing_height;
// TODO: Accomodate M6x45 bolt with M6 nut on one end
module BarrelWheelPlatform()
{
difference()
{
platform_height = (omniball_radius-barrel_omniball_radius)-(omniball_radius-bearing_height-drop_second_bearing)-bearing_height;
translate([0, 0, omniball_radius-bearing_height-drop_second_bearing+bearing_height])
color([1, 1, 0])
union()
{
cylinder(1, bearing_outer_radius-2, bearing_outer_radius);
translate([0, 0, 1])
cylinder(platform_height-1, bearing_outer_radius, bearing_outer_radius);
}

union()
{
    BarrelRodEntryVolume();
    PerfectBarrelWheelVolume();

}
}
}

module m3_bolt_volume(l=10, cl=0.2) {
    union() {
        // The Head (Cylinder)
        // Standard M3 head is 5.5mm. We add clearance to the diameter.
        translate([0, 0, 0])
            cylinder(d=5.5 + cl, h=3.0 + cl, $fn=32);
        
        // The Shank (Cylinder)
        // Standard M3 shank is 3.0mm.
        translate([0, 0, -l])
            cylinder(d=3.0 + cl, h=l + 0.01, $fn=32);
    }
}

module BarrelWheelClamp()
{

    intersection()
    {

    difference()
    {
    translate([0, 0, omniball_radius-bearing_height-drop_second_bearing+bearing_height+platform_height])
    color([1, 0, 1])
    cylinder(platform_height-3, bearing_outer_radius, bearing_outer_radius);

    union()
    {
        BarrelRodEntryVolume();
        PerfectBarrelWheelVolume();

    }
    }
    
    color([0.5, 0, 0.5])
    sphere(omniball_radius-2);

}
}


screw_sink = omniball_radius-bearing_height-drop_second_bearing+bearing_height+platform_height+platform_height-3-3;
module PlatformScrewHoles()
{
translate([0, -(barrel_omniball_radius+3), screw_sink])
m3_bolt_volume(l=30, cl=0.2);
translate([0, barrel_omniball_radius+3, screw_sink])
m3_bolt_volume(l=30, cl=0.2);
}


module PlatformScrews()
{

translate([0, -(barrel_omniball_radius+3), screw_sink])
screw("M3x30");
translate([0, barrel_omniball_radius+3, screw_sink])
screw("M3x30");
}

module ConnectorInserts()
{
// Okay perfect it fits lol
translate([0, barrel_omniball_radius+3, omniball_radius-barrel_omniball_radius-platform_height-4])
BrassInsert();

translate([0, barrel_omniball_radius+3, omniball_radius-barrel_omniball_radius-platform_height-10]) cylinder(10, 1.51, 1.51);

translate([0, -(barrel_omniball_radius+3), omniball_radius-barrel_omniball_radius-platform_height-4])
BrassInsert();

translate([0, -(barrel_omniball_radius+3), omniball_radius-barrel_omniball_radius-platform_height-4]) cylinder(10, 1.51, 1.51);
}

//ConnectorInserts();

//PlatformScrews();

//$fn=128;
////rotate([0, 180, 0])
difference()
{
BarrelWheelClamp();
PlatformScrewHoles();
}
//
NeoBearings();
//
difference()
{
BarrelWheelPlatform();
PlatformScrews();
}

//rotate([0, 180, 0])
//BarrelWheelClamp();


//BarrelRodEntryVolume();

//Semisphere();

//color([0, 1, 0, 0.1]) sphere(omniball_radius, $fn=128);
//HemisphereSection2();

module Underplat()
{
difference()
{
cylinder(omniball_radius-barrel_omniball_radius-platform_height, bearing_inner_radius, bearing_inner_radius);
// TODO: A really really big and critical design decision here is whether this piece should allow cutout by the wheel OR reduce the height of the higher bearing to match

union()
{
    ConnectorInserts();
    PerfectBarrelWheelVolume();
}

}
}

//intersection()
//{
//sphere(omniball_radius, $fn=128*2);
//translate([-omniball_radius+barrel_omniball_radius, 0, -barrel_wheel_height/2]) cylinder(barrel_wheel_height, barrel_omniball_radius, barrel_omniball_radius);
//}
//HemisphereConnector();


module PerfectBarrelWheelVolume(rad_mult = 0.5)
{
    wheel_curve_offset = -omniball_radius + barrel_omniball_radius*rad_mult;
    rotate([0, 90, 0])
    translate([wheel_curve_offset+barrel_omniball_radius*0.5, 0, 0])
    // difference()
    scale(1.05)
    {
        union()
        {
        rotate_extrude($fn=128)
        projection(cut=true)
        {
            translate([-wheel_curve_offset-barrel_omniball_radius*0.5, 0, 0])
            intersection()
            {
                sphere(omniball_radius, $fn=128*2);
                
                // Replacing the cylinder with a cube
                // We center the cube on the X and Y axes for a clean intersection

                translate([wheel_curve_offset, 0, 0]) 
                    cube([barrel_omniball_radius, barrel_wheel_height, barrel_wheel_height], center = true);
            }
        }
        }
    barrel_wheel_support_h = 35;
    color([0.5, 0.5, 0.5, 1.0])
    translate([0, 0, -barrel_wheel_support_h/2]) cylinder(barrel_wheel_support_h, 2.04, 2.04);
    }
}


module PerfectBarrelWheel(rad_mult = 0.5)
{
    wheel_curve_offset = -omniball_radius + barrel_omniball_radius*rad_mult;
    rotate([0, 90, 0])
    translate([wheel_curve_offset+barrel_omniball_radius*0.5, 0, 0])
    difference()
    {
        union()
        {
        rotate_extrude($fn=128)
        projection(cut=true)
        {
            translate([-wheel_curve_offset-barrel_omniball_radius*0.5, 0, 0])
            intersection()
            {
                sphere(omniball_radius, $fn=128*2);
                
                // Replacing the cylinder with a cube
                // We center the cube on the X and Y axes for a clean intersection

                translate([wheel_curve_offset, 0, 0]) 
                    cube([barrel_omniball_radius, barrel_wheel_height, barrel_wheel_height], center = true);
            }
        }
        }
    barrel_wheel_support_h = barrel_wheel_height + 1;
    color([0.5, 0.5, 0.5, 1.0])
    translate([0, 0, -barrel_wheel_support_h/2]) cylinder(barrel_wheel_support_h, 3.06, 3.06);
    }
}

// 3d print rot
//rotate([0, 90, 0])
PerfectBarrelWheel();

HemisphereSection2();

module ConnectorColumn()
{
difference()
{
union()
{
cylinder(axis_connection_thickness , inner_radius , inner_radius);
//// Bearing spacer
translate([0, 0, axis_connection_thickness])    
cylinder(hemisphere_connector_spacer_height, bearing_outer_radius-2, bearing_outer_radius-2);

Underplat();
}


rotate([0, 0, 90])
union()
{
translate([-inner_radius, 0, 0]) 
rotate([0, 90, 0])
cylinder(inner_radius*2, 4.02, 4.02);

translate([-inner_radius, 0, 0])
rotate([0, -90, 0])
nut("M8");

translate([inner_radius, 0, 0])
rotate([0, 90, 0])
nut("M8");

}

}
}


module NeoConnector()
{
difference()
{
ConnectorColumn();
rotate([0, 90, 0]) ConnectorCutout();
}
}


//NeoConnector();
//RightHemisphereConnector();


        
//PerfectBarrelWheel();

module Semisphere()
{
    difference()
    {
        sphere(omniball_radius);
        translate([-omniball_radius, -omniball_radius, -omniball_radius*2+axis_connection_thickness])

        cube([omniball_radius*2, omniball_radius*2, omniball_radius*2]);
    }
}

rotate([0, 90, 0])
SemisphereRing();

module SemisphereRing()
{
    difference()
    {
        sphere(omniball_radius);
        union()
        {
            // Remove the minimum region which the M8 rod must passthrough
            translate([-5, -omniball_radius, -omniball_radius])
            cube([omniball_radius*2, omniball_radius*2, omniball_radius*2]);
            
            // Remove the pole part of the hemisphere
            mirror([1, 0, 0]) translate([axis_connection_thickness+hemisphere_connector_spacer_height, -omniball_radius, -omniball_radius])
            cube([omniball_radius*2, omniball_radius*2, omniball_radius*2]);
            
            // Remove the region which overlaps the axis connectors
            // large 6mm spacing region just in case
            rotate([0, -90, 0]) cylinder(h=10+hemisphere_connector_spacer_height, r=inner_radius+6);
        }
    }
}

module HemisphereSection2()
{
    difference()
    {
        Semisphere();
        {
            translate([0, 0, axis_connection_thickness])
            cylinder(bearing_height, bearing_outer_radius, bearing_outer_radius);
            
            cylinder(omniball_radius, wheel_cutout, wheel_cutout);
            
            translate([0, 0, omniball_radius-bearing_height-drop_second_bearing])
            cylinder(omniball_radius, bearing_outer_radius, bearing_outer_radius);
            
            // Upper cut with padding
            translate([0, 0, omniball_radius-bearing_height-drop_second_bearing+bearing_height])
            cylinder(omniball_radius, bearing_outer_radius+1, bearing_outer_radius+1.5); // spacing between hemisphere and barrel wheel support platform
        }
    }
}

module HemisphereConnector(show_hemisphere_connector_section=true, show_barrel_region=true)
{   
    barrel_wheel_support_radius = wheel_cutout*2;
    screw_passthrough_depth = 2;
    barrel_wheel_vertical_padding = 0.5;
    cutout_width = barrel_wheel_height+barrel_wheel_vertical_padding;
    support_edge_width = (barrel_wheel_support_radius-cutout_width)/2;
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
        translate([-axis_connection_thickness -hemisphere_connector_spacer_height, 0, 0])    
        rotate([0, 90, 0]) cylinder(hemisphere_connector_spacer_height, 22/2, 22/2);
        }
        }
        //  hole
        BarrelWheelSupportRodHalf();
        }
        
        if (show_barrel_region)
        {
        //BarrelWheelPlacement();

        //rotate([0, -90, 0])
        //translate([0, 0, 40+screw_passthrough_depth])
        //M4Washer();

        //rotate([0, -90, 0])
        //translate([0, 0, 40+screw_passthrough_depth]) // -1.8 (button head!)
        //screw("M4x10");

        difference()
        {
            color([0.3, 0.9, 0.4, 0.5])
            hull()
            {
            // Barrel wheel support narrowing edge
            translate([-split_pos, 0, 0]) rotate([0, -90, 0]) cylinder(h=(omniball_radius-split_pos), r1=barrel_wheel_height/2, r2=barrel_wheel_height/2);
            translate([-split_pos, 0, 0]) rotate([0, -90, 0]) cylinder(h=(omniball_radius-split_pos)-4, r1=wheel_cutout, r2=wheel_cutout);
            }
            
            union()
            {
                //translate([barrel_wheel_offset, 0, 0])    cuboid([barrel_slot_offset, 40, barrel_wheel_height], rounding=0.5);

                
                
                translate([cuboid_offset-screw_passthrough_depth, 0, 0]) cuboid([cuboid_fixed_cut, 40, barrel_wheel_height+barrel_wheel_vertical_padding ], rounding=4.5);

                // fully cut off the tip of the support region
                translate([cuboid_offset-7, 0, 0]) cuboid([cuboid_fixed_cut, 40, barrel_wheel_height+barrel_wheel_vertical_padding], rounding=0.5);
                
                // TODO: 
                // TODO: Cutout 4mm cylinder for M4 screw to secure barrel wheel support piece
                BarrelWheelSupportRod(false);

                rotate([0, -90, 0]) 
                cylinder(h=barrel_wheel_slot_edge+screw_passthrough_depth+0.002, r1=2, r2=2);
                
            }
        }
        }
        
        
        // color([0.3, 0.3, 0.3, 1]) Bearings();
    }
    // dowel pin holes
    outer_taper_spacing = 0.08;
    translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(support_edge_width, 1.5+0.1+outer_taper_spacing, 1.5+0.1);
    translate([barrel_wheel_offset, 0, -wheel_cutout + support_edge_width + cutout_width]) cylinder((barrel_wheel_support_radius-cutout_width)/2, 1.5+0.1, 1.5+0.1+outer_taper_spacing);
    
    //translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(cuboid_offset-screw_passthrough_depth, 1.5+0.1, 1.5+0.1);
    //translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(wheel_cutout*2, 1.5+0.1, 1.5+0.1);
    }
    //color([0.9, 0.9, 0.9])
    //translate([barrel_wheel_offset, 0, -wheel_cutout]) cylinder(wheel_cutout*2, 1.5, 1.5);
    }
}

module SemiWrap()
{
    difference()
    {
        union()
        {
            HemisphereSection();
            SemisphereRing();
        }
        DowelPinInstallationSlit();
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
    color([0.5, 0.5, 0.5]) translate([0, omniball_radius+rod_pad, 0]) rotate([90, 0, 0]) cylinder((active_rod_height), 4, 4);
    
    color([0.5, 0.5, 0.5]) translate([0, -omniball_radius-rod_pad, 0]) rotate([-90, 0, 0]) cylinder((active_rod_height), 4, 4);
}

module ActiveRodsThreaded()
{
    // 60mm m8 threaded rods for active axis
    color([0.5, 0.5, 0.5]) translate([0, omniball_radius+rod_pad-active_rod_height/2, 0]) rotate([90, 0, 0]) threaded_rod(d=8, height=active_rod_height, pitch=1.25, $fa=1, $fs=1);
    
    color([0.5, 0.5, 0.5]) translate([0, -omniball_radius-rod_pad+
    active_rod_height/2, 0]) rotate([-90, 0, 0]) threaded_rod(d=8, height=active_rod_height, pitch=1.25, $fa=1, $fs=1);
}

nut_pos = [[-barrel_wheel_slot_edge-0.001, 0, 0], [barrel_wheel_slot_edge-6.5-0.001, 0, 0], [-3.25, 0, 0], [0, omniball_radius+rod_pad-active_rod_height+9.5, 0], [0, -omniball_radius-rod_pad+active_rod_height, 0]];

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
                for (i = [3:4])
                {
                    
                    translate(nut_pos[i])
                    rotate(nut_rot[i]) rotate([0, 0, 30]) scale(1.1) nut_trap_inline(9.5, "M8");
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
        //translate([7.5+1.5-axis_connection_thickness, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) screw_hole("M3", head="socket", thread="none", length=15, oversize=0.15);
        translate([7.5+1.5, 0, 0]) rotate([90, i*360/axis_connector_screws, -90]) translate([0, inner_radius-10, 0]) cylinder(18, 1.65, 1.65);
        //screw_hole("M3", head="socket", thread="none", length=15, oversize=0.15);
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

//CrossSection();



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

module ConnectorCutout()
{
    union()
    {
        AxisConnectionScrews();
        AxisConnectionScrewHeadCuts();
        AxisConnectionScrewNutCuts();
    }
}

//ConnectorCutout();

module RightHemisphereConnector()
{
    rotate([0, 90, 0])
    difference()
    {
        mirror([1, 0, 0]) HemisphereConnector(show_barrel_region=false);
        // I had to use stl diff due to a bug with OpenSCAD
        mirror([1, 0, 0]) ConnectorCutout();//import("connector_cutout.stl");
        //mirror([1, 0, 0]) ConnectorCutout();
    }
}

module LeftHemisphereConnector()
{   
    rotate([0, -90, 0])
    difference()
    {
        mirror([1, 0, 0]) HemisphereConnector(show_barrel_region=false);
        ConnectorCutout();
    }
}

module DowelPinInstallationSlit()
{
    hull()
    {
        translate([barrel_wheel_offset-10, 0, -wheel_cutout*5]) cylinder(wheel_cutout*10, 1.5, 1.5);
        translate([barrel_wheel_offset, 0, -wheel_cutout*5]) cylinder(wheel_cutout*10, 1.5, 1.5);
    }
}


//rotate([0, 90, 0]) SemiWrap();
//rotate([180, -90, 0]) SemiWrap();

// CrossSection();
//rotate([0, 90, 0]) SemiWrap();
//SemisphereRing();
// BarrelWheelSupportRod();
//HemisphereConnector();
//DowelPinInstallationSlit();
//BarrelWheelSupportRod();

//translate([0, 0, -split_pos]) rotate([0, 90, 0]) HemisphereConnector(show_hemisphere_connector_section=false);
//BarrelWheel();

// 3D print part renders
//BarrelWheel(); // x2

// BarrelWheelSupport x2
//translate([0, 0, -split_pos]) rotate([0, 90, 0]) HemisphereConnector(show_hemisphere_connector_section=false);


//LeftHemisphereConnector();
//rotate([0, 180, 0]) RightHemisphereConnector();

//ActiveRods();

//ConnectorCutout();