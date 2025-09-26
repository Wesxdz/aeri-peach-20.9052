include <dodecahedroid_config.scad>

// Pieces to screw onto the ends of screw sliders to secure peach core
// This can be soft to accomodate variation

// So rather than a brass insert it should use a nut catchment

// Alternatively: pour a silicon mold of the core

difference()
{
$fn=64;
scale([1, 2, 1]) cylinder(0.4, (0.7-0.02)/2, (0.7-0.02)/2);
//translate([-0.35, -0.35, 0]) cube([0.7, 0.7, 0.4], center=false);
BrassInsert();
}
