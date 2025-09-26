// Dodecahedron

include <nutsnbolts/cyl_head_bolt.scad>
include <dodecahedroid_config.scad>

include <core_platform.scad>
include <atx_compliance.scad>
//include <penta_composite.scad>

module DodecahedronSlice() {
    C0 = 0.809016994374947424102293417183;
    C1 = 1.30901699437494742410229341718;

    vert_points = [
        [ 0.0,  0.5,   C1],
        [ 0.0,  0.5,  -C1],
        [ 0.0, -0.5,   C1],
        [ 0.0, -0.5,  -C1],
        [  C1,  0.0,  0.5],
        [  C1,  0.0, -0.5],
        [ -C1,  0.0,  0.5],
        [ -C1,  0.0, -0.5],
        [ 0.5,   C1,  0.0],
        [ 0.5,  -C1,  0.0],
        [-0.5,   C1,  0.0],
        [-0.5,  -C1,  0.0],
        [  C0,   C0,   C0],
        [  C0,   C0,  -C0],
        [  C0,  -C0,   C0],
        [  C0,  -C0,  -C0],
        [ -C0,   C0,   C0],
        [ -C0,   C0,  -C0],
        [ -C0,  -C0,   C0],
        [ -C0,  -C0,  -C0]
    ];
    
    points = [
        [ 0.0,  0.5,   C1],
        [ 0.0,  0.5,  -C1],
        [ 0.0, -0.5,   C1],
        [ 0.0, -0.5,  -C1],
        [  C1,  0.0,  0.5],
        [  C1,  0.0, -0.5],
        [ -C1,  0.0,  0.5],
        [ -C1,  0.0, -0.5],
        [ 0.5,   C1,  0.0],
        [ 0.5,  -C1,  0.0],
        [-0.5,   C1,  0.0],
        [-0.5,  -C1,  0.0],
        [  C0,   C0,   C0],
        [  C0,   C0,  -C0],
        [  C0,  -C0,   C0],
        [  C0,  -C0,  -C0],
        [ -C0,   C0,   C0],
        [ -C0,   C0,  -C0],
        [ -C0,  -C0,   C0],
        [ -C0,  -C0,  -C0]
    ];

    faces = [
        [ 12,  4, 14,  2,  0],
        [ 16, 10,  8, 12,  0],
        [  2, 18,  6, 16,  0],
        [ 17, 10, 16,  6,  7],
        [ 19,  3,  1, 17,  7], // 0
        [  6, 18, 11, 19,  7],
        [ 15,  3, 19, 11,  9],
        [ 14,  4,  5, 15,  9],
        [ 11, 18,  2, 14,  9],
        [  8, 10, 17,  1, 13], // 1
        [  5,  4, 12,  8, 13],
        [  1,  3, 15,  5, 13] // 2
    ];

    rotate([-magic_angle, 0, 0]) polyhedron(points, faces);
}

platform_sink = 0.2;
surface_bed_z = -8-platform_sink;

module Sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module MotherPlatformSection(depth = 0.5, radius, angles, fn)
{
    linear_extrude(depth)
    Sector(radius, angles, fn);
}

module MotherPiExportSections(sections=[1, 1, 1], depth=3)
{
    union()
    {
    if (sections[0])
    {
    color([0.5, 0.0, 1.0, 0.5])
    MotherPlatformSection(depth, 30, [30, 150], 24);
    }
    if (sections[1])
    {
    color([1.0, 0.5, 1.0, 0.5])
    MotherPlatformSection(depth, 30, [150, 270], 24);
    }
    if (sections[2])
    {
    color([1.0, 0.0, 0.0, 0.5])
    MotherPlatformSection(depth, 30, [30, -90], 24);
    }
    }
}

module MotherPiSections(depth=0.5)
{
    union()
    {
    color([0.5, 0.0, 1.0, 0.5])
    MotherPlatformSection(depth, 30, [30, 150], 24);
    color([1.0, 0.5, 1.0, 0.5])
    MotherPlatformSection(depth, 30, [150, 270], 24);
    color([1.0, 0.0, 0.0, 0.5])
    MotherPlatformSection(depth, 30, [30, -90], 24);
    }
}

module MotherConnectorAttach()
{
$fn = 32;
    translate([-13.8845, 17.9992, 0.0]) scale(0.1) screw("M3x20");
    translate([13.8845, 17.9992, 0.0]) scale(0.1) screw("M3x20");
    
    translate([-8.64556, -21.0239, 0.0]) scale(0.1) screw("M3x20");
    translate([8.64556, -21.0239, 0.0]) scale(0.1) screw("M3x20");
    
    translate([-22.53, 3.02468, 0.0]) scale(0.1) screw("M3x20");
    translate([22.53, 3.02468, 0.0]) scale(0.1) screw("M3x20");
}


module MotherConnectorInsert()
{
    insert_points = [
    [-13.8845, 17.9992, 0.0],
    [13.8845, 17.9992, 0.0],
    [-8.64556, -21.0239, 0.0],
    [8.64556, -21.0239, 0.0],
    [-22.53, 3.02468, 0.0],
    [22.53, 3.02468, 0.0]
    ];
    
    $fn = 32;
    for (i = [0:len(insert_points)-1])
    {
        translate(insert_points[i])
        {
        scale(0.1) screw("M3x16");
        color([1.0, 0.5, 1.0, 0.5])
        translate([0, 0, -brass_insert_height]) BrassInsert();
        }
    }
}

module MotherConnectorCutout()
{
nutcatch_depth = 0.6;
$fn = 32;
    translate([-13.8845, 17.9992, 0.0]) 
    {
        scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90-dihedral])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
    translate([13.8845, 17.9992, 0.0])
    {
    scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90-dihedral-(180-dihedral)*2])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
    
    translate([-8.64556, -21.0239, 0.0]) 
    {
        scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
    
    translate([8.64556, -21.0239, 0.0]) 
    {
        scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
    
    translate([-22.53, 3.02468, 0.0])
    {
        scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90-dihedral])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
    
    translate([22.53, 3.02468, 0.0]) 
    {
        scale(0.1) screw("M3x20");
        translate([0.0, 0.0, -nutcatch_depth]) 
        rotate([0, 0, -90-dihedral-(180-dihedral)*2])
        scale(0.1) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
    }
}

module MotherPlatformBase(depth=0.5)
{
    intersection()
    {
    scale(interior_scale) DodecahedronSlice();
    translate([0, 0, surface_bed_z]) MotherPiSections(depth);
    }
}
// GPU at front...
//rotate([180, 90+magic_angle, 90])

module MotherPlatform()
{
difference()
{
union()
{
difference()
{
    MotherPlatformBase();
    $fn=36;
//rotate([0, 90+magic_angle, 90])
translate([0, 0, surface_bed_z])
rotate([0, 90, 90])
translate([-0.5-atx_board_depth , -atx_board_height/2, -14])
    {
    ATXMotherboardMount();
    rotate([0, -90, 0]) 
    {
    ATXPowerPassthrough();
    AtxSupportSlit();
    }
    
    //ATXMotherboardVolume();
    }
}
translate([0, 0, surface_bed_z])
rotate([0, 90, 90])
translate([-0.5-0.8, -atx_board_height/2, -14])
{
    ATXMotherboardMountSurface();
}
}
translate([0, 0, surface_bed_z])
rotate([0, 90, 90])
translate([-0.5-0.8, -atx_board_height/2, -14])
{
    ATXMotherboardMountCave();
}
}

show_atx = false;
if (show_atx)
{
translate([0, 0, surface_bed_z-.3])
rotate([0, 90, 90])
translate([-0.5-0.8-atx_board_depth, -atx_board_height/2, -14])
    {
rotate([0, -90, 0]) ATXSpecification();
}
}
}

module InnerPlatform()
{
difference()
{
MotherPlatform();
PlatformPentaVolume(1.02);
}
}

module MotherPlatformIntegrated()
{
difference()
{
union()
{
render()
InnerPlatform();
intersection()
{
MotherPlatform();
scale([0.967, 0.967, 1.0]) MotherPlatformBase();
}
}
for (i = [0:3])
{
translate([0, 0, surface_bed_z+0.4])
rotate([0, 0, -30+120*i])
translate([-8, 0, 0])
// 1.0mm clearance
RoundedRect(2+0.1, 2+0.1, 0.5, 2);
}
}
}

module RoundedRect(w, h, d, r)
{
translate([-w/2, -h/2, 0]) 
linear_extrude(d)
hull()
{
$fn=64;
circle(r);
translate([w, 0, 0]) circle(r);
translate([w, h, 0]) circle(r);
translate([0, h, 0]) circle(r);
}
}

module MothershipPlatformExport()
{
difference()
{
MotherPlatformIntegrated();
union()
{

merger_mount_points = [[1.0, 1.0, 0.0], [-1.0, 1.0, 0.0], [1.0, -1.0, 0.0], [-1.0, -1.0, 0.0]];

for (i = [0:3])
{
translate([0, 0, surface_bed_z+0.4])
rotate([0, 0, -30+120*i])

translate([-8, 0, 0])
{
for (z=[0:len(merger_mount_points)-1])
{
$fn = 32;
translate(merger_mount_points[z]*1.5)
translate([0, 0, 0.5]) rotate([0, 180, 0]) cylinder(30, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
//translate([0, 0, 0.5]) scale(0.1) screw("M3x12");
}
}
}

}
}

// import ("penta_composite.stl");
//import ("mothership_connectors.stl");
intersection()
{
PlatformPentaDocks();
//import ("mothership_total_war.stl");
intersection()
{
//scale(interior_scale) DodecahedronSlice();
translate([0, 0, surface_bed_z])
MotherPiSections(2);
}
}
}




module MothershipPlatformPreview()
{
merger_mount_points = [[1.0, 1.0, 0.0], [-1.0, 1.0, 0.0], [1.0, -1.0, 0.0], [-1.0, -1.0, 0.0]];

for (i = [0:3])
{
translate([0, 0, surface_bed_z+0.4])
rotate([0, 0, -30+120*i])
translate([-8, 0, 0])
{
difference()
{
RoundedRect(2, 2, 0.5, 2);
union()
{
for (z=[0:len(merger_mount_points)-1])
{
$fn=64;
translate(merger_mount_points[z]*1.5)
cylinder(4, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
//translate([0, 0, 0.5]) scale(0.1) screw("M3x12");
}
}
}
}
}
}

MotherPlatformIntegrated();

//MothershipPlatformPreview();
intersection()
{
difference()
{
MothershipPlatformExport();
PlatformPentaDockHoles();
}
translate([0, 0, surface_bed_z]) MotherPiExportSections([0, 0, 0]);
}