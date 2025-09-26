include <dodecahedroid_config.scad>
include <nutsnbolts/cyl_head_bolt.scad>
include <keyboard/cherrymx.scad>
include <switch/holder.scad>
include <switch/roundedCube.scad>

$fn = 64;

module PeachCore()
{
scale(0.8)
hull()
{
translate([0, 0, 3]) scale([1.0, 0.7, 1.0]) sphere(0.2);
translate([0, 0, 2]) scale([1.0, 0.7, 1.0]) sphere(1);
scale([1.0, 0.9, 1.0]) translate([0, 0, 0.6]) sphere(2.0);
//sphere(1.8);
//translate([0, 0, -0.1]) sphere(2.0);
translate([0, 0, -1.4]) scale([1.0, 0.9, 1.0]) cube([1.7, 1.0, 1.0], center=true);
}
}

module PeachPit()
{
hull()
{
PeachCore();
scale([1.1, 0.2, 1.1]) PeachCore();
}
}

module PeachScoop()
{
    difference()
    {
        PeachPit();
        translate([0, -1 - 0., 0]) cube([12.0, 2.0, 12.0], center=true);
        scale(0.9) PeachPit();

    }
}

module PeachPowerHoles(slider_distance=0.3, hole_rad = .15 + 0.01)
{
    translate([0, 0.3, 0]) 
    {
        translate([0, 0, 0]) rotate([0, 180, 0]) hull()
        {
        cylinder(3, hole_rad, hole_rad);
        translate([0, slider_distance, 0]) cylinder(3, hole_rad, hole_rad);
        }
        
        translate([1.7, 0, 1.7]) rotate([0, 60+180, 0]) hull()
        {
        cylinder(3, hole_rad, hole_rad);
        translate([0, slider_distance, 0]) cylinder(3, hole_rad, hole_rad);
        }
        
        mirror([1, 0, 0]) translate([1.7, 0, 1.7]) rotate([0, 60+180, 0]) hull()
        {
        cylinder(3, hole_rad, hole_rad);
        translate([0, slider_distance, 0]) cylinder(3, hole_rad, hole_rad);
        }
    }
}

module PeachPrintScoop()
{
    difference()
    {
    // translate([0, -panel_thickness, 0]) 
        union()
        {
        rotate([-90, 0, 0]) linear_extrude(1.7) projection(cut = true) rotate([90, 0, 0]) scale([1.1, 1.0, 1.1]) PeachContour();
        difference()
        {
        color([0.5, 0.1, 0.0, 0.4])
        hull()
        {
        translate([0, -0.5, 0]) rotate([-90, 0, 0]) linear_extrude(panel_thickness) projection(cut = true) rotate([90, 0, 0]) PeachContourOutlineBlock();
        translate([0, 1, 0]) rotate([-90, 0, 0]) linear_extrude(0.1) projection(cut = true) rotate([90, 0, 0]) PeachContourOutline();
        }
        translate([0, -0.7, 0]) PeachPowerHoles(slider_distance=0.8, hole_rad = .3 + 0.02);
        }
        }
        PeachCore();
    }
}

module PeachPower(slider_distance=0.3)
{
difference()
{

difference()
{

}

translate([0, -1 - 0., 0]) cube([12.0, 2.0, 12.0], center=true);
scale(0.9) PeachPit();
}
}

module PeachSystem()
{

difference()
{
PeachPower();
// Mechanical switch slot
translate([0, 1.5, 0.5]) cube(1.6, center=true);
}


translate([0, 0.4, 0.5]) scale(0.1) rotate([90, 0, 0]) CherryMX();

//color([0.1, 0.1, 0.1, 0.5]) translate([0, -0.4, 0]) scale(0.8) PeachPit();
}


difference()
{
//PeachScoop();
//translate([0.0, 0.1, 0.0]) PeachPit();
}

module PeachContour()
{
    difference()
    {
    PeachCore();
    translate([0, -5.01, 0]) cube([10, 10, 10], center=true);
    mirror([0, 1, 0]) translate([0, -5.01, 0]) cube([10, 10, 10], center=true);
    }
}

module PeachContourOutline()
{
difference() {
scale([1.1, 1.0, 1.1]) PeachContour();
scale([1.0, 1.0, 1.0]) PeachContour();
}
}

module PeachContourOutlineBlock()
{
union()
{
difference() {
scale([1.2, 1.0, 1.2]) PeachContour();
scale([1.0, 1.0, 1.0]) PeachContour();
}
cube([5.2, 1, 1], center=true); // wings
}
}

module SwitchAnchor()
{
difference()
{
union()
{
rotate([-180, 0, 0]) scale (0.1) SwitchHolder();
translate([0, 1.05 + 0.6, 0.25]) cube([1.0, 1.2, .5], center=true);
mirror([0, 1, 0]) translate([0, 1.05 + 0.6, 0.25]) cube([1.0, 1.2, .5], center=true);
}

translate([0, 1.8, 0])
{
cylinder(1, m3_rad, m3_rad);
}

translate([0, -1.8, 0])
{
cylinder(1, m3_rad, m3_rad);
}


}

//rotate([180, 0, 0])
//{
//translate([0, 1.8, 0]) scale(0.1)
//{
//screw("M3x16");
//translate([0, 0, -5]) nut("M3");
//}
//mirror([0, 1, 0]) translate([0, 1.8, 0]) scale(0.1) 
//{
//screw("M3x16");
//translate([0, 0, -5]) nut("M3");
//}
//}
}

//SwitchAnchor();

module PeachPanelMountHoles()
{

wing_spread = 2.5;
flat_offset = 0.4;

mirror([1, 0, 0]) translate([wing_spread, 0, 0]) rotate([90, 0, 0]) cylinder(panel_thickness*2, m3_rad, m3_rad);

translate([wing_spread, 0, 0]) rotate([90, 0, 0]) cylinder(panel_thickness*2, m3_rad, m3_rad);
}

module PeachPanelMountScrews()
{
wing_spread = 2.5;
flat_offset = 0.4;

mirror([1, 0, 0]) translate([wing_spread, 0, 0]) rotate([180, 0, 0]) scale(0.1) screw("M3x8");

translate([wing_spread, 0, 0]) rotate([180, 0, 0]) scale(0.1) screw("M3x8");
}

module PeachPanelMountNoVent()
{

wing_spread = 2.2;
flat_offset = 0.4;

//mirror([1, 0, 0]) translate([wing_spread, -panel_thickness, ]) rotate([90, 0, 0]) scale(0.1) screw("M3x12");
mirror([1, 0, 0]) translate([wing_spread, 0, 0]) rotate([90, 0, 0]) cylinder(panel_thickness, 1, 1);

translate([wing_spread, 0, 0]) rotate([90, 0, 0]) cylinder(panel_thickness, 1, 1);
}

module PeachFantasy()
{
PeachSystem();


difference()
{
union()
{

difference()
{
color([0.9, 0.4, 0.0, 0.6])
PeachPrintScoop();

union()
{
mirror([1, 0, 0]) translate([wing_spread, 0, 0]) rotate([-90, 0, 0]) cylinder(4, 0.15, 0.15);
mirror([1, 0, 0]) translate([wing_spread, 0, 0]) rotate([-90, 0, 0]) BrassInsert();

translate([wing_spread, 0, 0]) rotate([-90, 0, 0]) cylinder(4, 0.15, 0.15);
translate([wing_spread, flat_offset, 0]) rotate([90, 0, 0]) BrassInsert();

scale(0.1) translate([0, 0, 5]) rotate([90, 0, 0]) roundedCube([21.05, 21.05, 40], r=2, center=true);
}
}

wing_spread = 2.2;
flat_offset = 0.4;

// Anchor secure screws
mirror([1, 0, 0]) translate([wing_spread, -panel_thickness-0.5, ]) rotate([90, 0, 0]) scale(0.1) screw("M3x12");
translate([wing_spread, -panel_thickness-0.5, 0]) rotate([90, 0, 0]) scale(0.1) screw("M3x12");

slider_distance = 0.5;

difference()
{
color([1.0, 0.1, 0.0, 0.4])
translate([0, -panel_thickness-slider_distance, 0]) rotate([-90, 0, 0]) linear_extrude(panel_thickness+slider_distance) projection(cut = true) rotate([90, 0, 0]) PeachContourOutline();
}

}
translate([0, -0.5-panel_thickness, 0]) rotate([-90, 0, 0]) linear_extrude(1.21) projection(cut = true) rotate([90, 0, 0]) PeachContour();
}

color([1, 1, 1, 0.1])
translate([0, 0.0, 0.5]) translate([0, 2, 0]) 
{
rotate([-270, 0, 0]) SwitchAnchor();
}
}

//PeachPanelMountHoles();
//PeachFantasy();

module KeycapAttachment()
{
scale(0.1)
union()
{
$fn=128;
translate([0, 0, 3.62/2]) linear_extrude(1) scale([0.6, 0.9, 1]) circle(8);
difference()
{
cylinder(3.62, 5.5/2, 5.5/2, center=true);
color("brown"){
        cube([1.35,4.5,3.62], center=true);
        cube([4.5,1.15,3.62], center=true);
}
}
}
}


//translate([0, 0, 2]) rotate([180, 0, 90-18])
//{
//scale(10) rotate([0, 180, 0]) SwitchAnchor();
//translate([0, 0, 1.2]) rotate([0, 0, 90]) KeycapAttachment();
//translate([0, 0, 1.7]) scale(0.1) rotate([0, 0, 90]) CherryMX();
//}