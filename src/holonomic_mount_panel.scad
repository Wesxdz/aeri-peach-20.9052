include <connector_pentagon_plate.scad>

$fn=36;
module HolonomicMountPanel()
{
scale(10) 
difference()
{
NeoCradlePanel();

hull()
{
translate([1, 6, 0])
cylinder(panel_height, 2.8, 2.8);

translate([-4, 5, 0]) 
cylinder(panel_height, 2.5, 2.5);
}

mirror([0, 1, 0])
hull()
{
translate([1, 6, 0])
cylinder(panel_height, 2.8, 2.8
);

translate([-4, 5, 0])
cylinder(panel_height, 2.5, 2.5);
}
}
}

HolonomicMountPanel();

//TruncatedPlate();