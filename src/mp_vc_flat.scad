include <mother_platform.scad>
include <dodecahedroid_config.scad>
include <vertex_connector.scad>

module PlatformVertexConnectors(connectors, con_color, upper_platform = 0)
difference()
{
union()
{
//color([1.0, 0.0, 1.0, 1.0])
//import ("mothership_connectors.stl");

difference()
{
//color([0.0, 1.0, 1.0, 1.0])
//import ("escape_pod_connectors.stl");
color(con_color)
import(connectors);

union()
{
// TODO: What should be the scale clearance?
translate([0, 0, -0.05]) scale([0.97, 0.97, 1.0]) MotherPlatformBase(0.5+0.1); // Mother platform base with clearance
}

difference()
{
// The upper dock
intersection()
{
PlatformPentaDocks(0.05);
translate([0, 0, surface_bed_z])
MotherPiSections(2);
}
}
}
}

union()
{
if (upper_platform)
{
translate([0, 0, 20]) cube([80, 80, 40], center=true);
translate([0, 0, -20-(7.722)]) cube([80, 80, 40], center=true);
}
if (!upper_platform)
{
translate([0, 0, 20-(7.722)]) cube([80, 80, 40], center=true);
}
translate([0, 0, (7.722)-42]) cube([80, 80, 40], center=true);
}
}


//difference()
//{
//difference()
//{
//PlatformVertexConnectors();
//rotate([0, 0, 180]) translate([0, 0, -0.20]) scale([0.97, 0.97, 1.0]) import("mother_platform.stl");
//}
//
////color([1.0, 0.0, 0.5, 0.5])
////translate([0, 0, -0.25]) scale([0.97, 0.97, 1.0]) import("mother_platform.stl");
//
//rotate([0, 0, 180])
//translate([0, 0, surface_bed_z]) MotherConnectorInsert();
//
//}

// These are notch sections cropped and attached to mothership connectors
//PlatformVertexConnectors("platform_connectors.stl", [0.0, 1.0, 1.0, 1.0], 0);

//PlatformVertexConnectors("platform_connectors.stl", [1.0, 0.0, 1.0, 1.0], 0);

// translate([0, 2, 2]) PlatformVertexConnectors("escape_pod_connectors.stl", [0.0, 1.0, 1.0, 1.0], 1);

//intersection()
//{
//translate([0, 0, 0]) PlatformVertexConnectors("platform_connectors.stl", [1.0, 0.0, 1.0, 1.0], 1);
//import("escape_pod_connectors.stl");
//}
//color([0.8, 0.8, 0.9, 0.5])
//import("mother_platform_full.stl");

//MotherConnectorAttach();
//rotate([0, 0, 180])
//translate([0, 0, surface_bed_z+0.3])
//MotherConnectorAttach();

//import("mothership_connectors.stl");

//import("mothership_platform_screws.stl");