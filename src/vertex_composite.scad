include <dodecahedroid_config.scad>
include <penta_connector.scad>

include <dodecahedron_inner_volume.scad>

//include <cradle_brace.scad>


mothership_connectors = [
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[1, 0, 0, 0, 1], // Front right panel thumbscrews
[1, 1, 1, 1, 1],
[1, 1, 1, 1, 1],
[1, 1, 1, 1, 1],
[1, 1, 1, 1, 1],
[0, 0, 0, 1, 1], // Back panel thumbscrews
[1, 1, 1, 1, 1],
[0, 0, 1, 1, 0], // Front left panel thumbscrew
[1, 1, 1, 1, 1],
];

notch_security =
[
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[0, 0, 0, 0, 0],
[0, 1, 0, 0, 1],
[0, 0, 0, 0, 0],
[0, 0, 1, 1, 0],
[1, 0, 1, 0, 0],
[1, 1, 0, 0, 0],
[0, 0, 0, 0, 0],
[1, 1, 0, 0, 0],
[0, 1, 0, 1, 0],
[0, 0, 0, 0, 0],
];

full_connectors = [1, 1, 1, 1, 1];

module PentaVolume()        
{
standard_panel_rots = [36, -36*4.5, 0, 18, 36, -18, 18, -18, 18, 36+18+36*6, 18, 0+36*4];

union()
rotate([0, 0, 180])
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) 
{
translate(pos[i]*inner_panel_edge_length) rotate(rots[i]) rotate([0, 0, standard_panel_rots [i]]) 
    {

//        if (face_groups [i] == 3)
//        {
//            //PanelSubConnectorsCradle(z_rot=[120, 0, 0, 0, 0]);
//        }
        if (i == 4)
        {
            // TODO: Consider boolean mask
            // instead of pi-slicing every vertex connector...
            // ie toggle 2 off to prevent duplicate rendering
            PanelSubConnectorsCradle(z_rot=[90, 0, 0, 0, 0]);
        }
        else if (i == 9)
        {
            PanelSubConnectorsCradle(z_rot=[90+120, 0, 0, 0, 0]);
        }
        else if (i == 11)
        {
            PanelSubConnectorsCradle(z_rot=[90+120*2, 0, 0, 0, 0]);
        }
        else if (i == 0)
        {
            //PanelSubConnectorsNoseCone(array=[1, 1, 1, 1, 3]);
        } else if (i == 2)
        {
            //PanelSubConnectorsNoseCone(array=[1, 1, 1, 3, 1]);
        } else if (i == 8)
        {
            //PanelSubConnectorsNoseCone(array=[1, 3, 1, 1, 1]);
        }
        else
        {
            //PanelSubConnectors(full_connectors, notch_security[i]);
        }
    }
}
}
}

module PlatformPentaDocks(clearance=0.0)        
{
standard_panel_rots = [36, -36*4.5, 0, 18, 36, -18, 18, -18, 18, 36+18, 18, 0];
intersection()
{
union()
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) 
{
translate(pos[i]*inner_panel_edge_length) rotate(rots[i]) rotate([0, 0, standard_panel_rots [i]]) 
    {
    PanelSubConnectorsDocks(full_connectors, clearance);
    }
}
}
translate([0, 0, -8]) cube([50, 50, 12], center=true);
}
}

module PlatformPentaDockHoles()        
{
standard_panel_rots = [36, -36*4.5, 0, 18, 36, -18, 18, -18, 18, 36+18, 18, 0];
intersection()
{
union()
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) 
{
translate(pos[i]*inner_panel_edge_length) rotate(rots[i]) rotate([0, 0, standard_panel_rots [i]]) 
    {
    PanelSubConnectorsDockHoles(full_connectors);
    }
}
}
translate([0, 0, -8]) cube([50, 50, 12], center=true);
}
}


module PlatformPentaVolume(clearance_scale = 1.0)       
{
standard_panel_rots = [36, -36*4.5, 0, 18, 36, -18, 18, -18, 18, 36+18, 18, 0];
intersection()
{
union()
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) 
{
translate(pos[i]*inner_panel_edge_length) rotate(rots[i]) rotate([0, 0, standard_panel_rots [i]]) 
    {
    // scale here to prevent nonsolid planar stl explort artifacts
    // mother_platform.scad has this module as a dependency
    // if you modify the vertex cutoff of the module below
    // you will invalidate the design of the mother platform
    scale(1.00001) PanelSubConnectors(full_connectors, notch_security[i], 0.0, clearance_scale);
    difference()
    {
    //PanelSubConnectors(full_connectors, notch_security[i], 0.5, false, false, clearance_scale);
    //PanelSubConnectorsDockHoles();
    }
    }
}
}
translate([0, 0, -8]) cube([50, 50, 12], center=true);
}
}

//PanelSubConnectors(full_connectors, notch_security[0]);

scale(10)
rotate([0, 180, 0])
difference()
{
color([1, 0, 0, 1])
translate([0, 0, -height_vertical-vertex_tehtra_height_truncation])
rotate([0, 0, -90])
{
//BaseMountAttachment();
translate([0, 0, -0.1])
scale(0.1)
rotate([0, 180, 0])
CentralOmniballMountSupport();
}

PentaVolume();
}

//export_platform_connectors = false;
//if (export_platform_connectors)
//{
//intersection()
//{
//PlatformPentaVolume();
//// Just the six platform connectors
//translate([0, 0, -8]) cube([50, 50, 12], center=true);
//}
//}
//
//preview_docks = false;
//if (preview_docks)
//{
//difference()
//{
//PlatformPentaDocks();
//PlatformPentaDockHoles();
//}
//}

// $fn=12;
// scale(10) translate([0, 0, dodecahedron_radius+vertex_tehtra_height_truncation]) 
// {
//     PentaVolume();
    //import("vertex_composite_core.stl");
// }
// translate([0, 0, -dodecahedron_radius-vertex_tehtra_height_truncation]) rotate([0, 0, 30]) scale(.1) import("lift_mount_vertex_connector.stl");
//color([1, 0, 0, 1])
//scale(10) translate([0, 0, -dodecahedron_radius-vertex_tehtra_height_truncation]) rotate([0, 0, 30]) scale(.1) import("telescoping_lift.stl");
 //rotate([0, 0, 30]) IntegratedLift();

//PlatformPentaVolume();

//color([0.5, 0.5, 0.5, 0.5])
//scale(interior_scale) DodecahedronSlice();