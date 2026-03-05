include <crinoline.scad>

import("trunc_frame.stl");
translate([0, 4, -10]) 
rotate([0, 0, -90]) scale(0.1) import("lift.stl");

translate([0, 0, 86])
cylinder(2, 16, 16);
translate([0, 0, -20]) Crinoline();

for (i = [0:2])
{
rotate([0, 0, 120*i])
translate([0, -16, -23])
sphere(6);
}