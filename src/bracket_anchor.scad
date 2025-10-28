include <dodecahedroid_config.scad>
include <gt2_20_pulley.scad>
include <nutsnbolts/cyl_head_bolt.scad>

// https://www.pololu.com/product/1084
module GearmotorBracket(show_screws=false)
{
scale(0.1)
translate([-7.8, 1, (37.6+2)/2]) rotate([90, 0, 90]) union()
{ 
color([0.8, 0.8, 0.8, 1.0]) import("gearmotor_bracket.stl");

color([0.4, 0.4, 0.4, 1.0]) translate([-21, 1, -14]) import("37d-gearmotor-19-30-encoder.stl");
}
if (show_screws)
{
    $fn=36;
    translate([-0.84, 3.12/2, 0.2]) scale(0.1) screw("M3x12");
    translate([-0.84, -3.12/2, 0.2]) scale(0.1) screw("M3x12");

    translate([-0.84 - 0.64 * 6, 3.12/2, 0.2]) scale(0.1) screw("M3x12");
    translate([-0.84 - 0.64 * 6, -3.12/2, 0.2]) scale(0.1) screw("M3x12");
}
}

module M3Slot()
{
    rotate([0, 180, 0]) cylinder(1, 0.15+0.05, 0.15+0.05);
}
module GearmotorBracketScrewHoles()
{
    $fn=32;
    for (i = [0:6])
    {
        translate([-0.84 - 0.64 * i, 3.12/2, 0.0]) M3Slot();
        translate([-0.84 - 0.64 * i, -3.12/2, 0.0]) M3Slot();
    }
}

module BeltLoop(perimeter=20.0, belt_width=0.6, start_loop_rad=0.6, end_loop_rad=0.6)
{
    $fn=32;
    loop_length = ( perimeter-(PI*(start_loop_rad+end_loop_rad)) )/2;
    linear_extrude(belt_width)
    {
        difference()
        {
            hull()
            {

                circle(start_loop_rad);
                translate([loop_length, 0, 0]) circle(end_loop_rad);
            }
            hull()
            {

                circle(start_loop_rad-0.1);
                translate([loop_length, 0, 0]) circle(end_loop_rad-0.1);
            }
        }
    }
}

module MotorAttachment()
{
    // 1.38cm is the height above plane of the center of the pulley, this is used in calculations of wheel mount or belt length
    //translate([2, 0, 1.38/2]) cube([1, 1, 1.38], center=true);
    GearmotorBracket();
    color([1, 0.2, 0.1, 0.8]) translate([1.65, 0, 1.5]) rotate([0, 90, 0]) BeltLoop();
    color([1.0, 0.0, 1.0, 1.0]) translate([0.8, 0, 1.4]) rotate([0, 90, 0]) GT2_20_Pulley();
}

// MotorAttachment();
//difference()
//{
//translate([0, 0, -panel_thickness/2]) cube([12, 12, panel_thickness], center=true);
//GearmotorBracketScrewHoles();
//}
