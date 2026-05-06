
include <vertex_structure.scad>
include <ari_shiguchi.scad>

include<BOSL2/std.scad>
$fn=36*2;

module VertexMegichiMount()
{
    rotate([180, 0, 0])
    difference()
    {
    //VertexConnectorToTriangularPrism();
    // I had to export this as an STL from vertex_connector because i have limited memory capabilies and consequently mistakenly developed the new part in that depreciated file
    // TODO: Refactor/fix
    import("vertex_connector_to_triangular_prism.stl");
    rotate([180, 0, 0])
    rotate([magic_angle*2, 0, 0])
    translate([0, -11, -20])
    Oguchi(h=24, nw=16, jd=10, ang=10, bw=50, bd=30, is_cutout=true);
    }
}

module MountingInterface()
{
    difference()
    {
        for (i=[0:3])
        {
            rotate([0, 180, 120*i])
            rotate([-magic_angle*2, 0, 0])
            translate([0, inner_panel_edge_length*10, 0])
            VertexMegichiMount();
        }
    }
}

module OmniballBrace()
{

    //bez = [[0,0], [100,0], [100,100]];
    bez = [[0,0], [40,16], [40,88]];
    path = bezpath_curve(bez, N = 2);


    module CurvedSupport()
    {
    linear_extrude(40)
    stroke(path, width=16, $fn=36*2);
    }




    union()
    {
    translate([0, 11, -4.15])
    {
    rotate([0, 0, 180])
    Oguchi(h=16, nw=16, jd=10, ang=10, bw=40, bd=8, is_cutout=false);

    translate([-20, 8, 8])
    rotate([90, 0, 0])
    rotate([0, 90,0])
    {
        CurvedSupport();
    }
    }
    }
}

module VertexConnectorBrace(print_layout=true)
{
bearing_cutout = 11;

if (!print_layout)
{
    VertexMegichiMount();
}

rotate([print_layout ? 0 : magic_angle*2, 0, 0])
rotate([0, print_layout ? 0 : 90, 180])
union()
{
difference()
{
rotate([0, 90, 0])
OmniballBrace();

// TODO: Cutout 608 volume HERE

    union()
    {
    translate([85, 0, 0])
    rotate([-90, 0, 0])
    cylinder(100, 4.2, 4.2, $fn=36); // The M8 rod should passthrough frictionless
//    cylinder(100, 4.05, 4.05, $fn=36);

    translate([85, 60, 0])
    rotate([-90, 0, 0])
    cylinder(h=7, r1=bearing_cutout, r2=bearing_cutout);
    }
}

if (!print_layout)
{
    translate([85, -142, 0])
    rotate([-90, 0, 0])
    cylinder(210, 4.2, 4.2, $fn=36);

    // -116 is just approximate, it's pretty hard to calculate this value from the trig involved in the vertex junction
    // but should be eventually figured out!
    translate([85, -105, 0])
    rotate([-90, 0, 0])
    cylinder(h=7, r1=bearing_cutout, r2=bearing_cutout, $fn=36);
}

}
}

//translate([100, 0, 0]) 
//scale(10) VertexConnector();
//
//VertexConnectorBrace(true);