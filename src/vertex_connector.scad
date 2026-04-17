// DEPRECIATED in favor of vertex_structure.scad

// Brass insert
include <atx_compliance.scad>
include <nutsnbolts/cyl_head_bolt.scad>
include <dodecahedroid_config.scad>



// Constants
C0 = 0.809016994374947424102293417183;
C1 = 1.30901699437494742410229341718;

// just got this from Blender stl
connector_height = .252338;
// Polyhedron definition
module Dodecahedron(bot_offset = 0.0) {
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

    // Render polyhedron
    difference()
    {
    // if it were a cube, we'd rotate 45
    // however it's a dodecahedron
    // so we use tetrahedron angle C
    // 0.09224 is an approximation, since I'm not sure how to calculate this easily
    translate([0, 0, C1-.088]) rotate([-magic_angle, 0, 0]) polyhedron(points, faces);
    s = 50;
    translate([-s/2, -s/2, bot_offset]) cube([s,s,10]);
    }
    //for (f = [0 : len(faces)-1]) {
for (f = [0 : 0]) {
    center = [0.0, 0.0, 0.0];
    echo(center);
    for (v = [0 : len(faces[f])-1]) {
        echo("Index:", faces[f][v]);
        echo("Point:", points[faces[f][v]]);
        center = center + points[faces[f][v]];
        echo(center);
    }
    echo(center);
}
}

// // DEPRECIATED
module VertexConnector(secure=0, vertex_cutoff = 0.0, show_screw_holes = true, show_screws=false, power_variant=false, dodeca_cut = 2.88386, lower_dodeca=0.0)
{

    secure =  (power_variant ? 1: secure);
    multi_secure_spacing = power_variant ? power_secure_spacing : standard_secure_spacing;
    // Nut hold vs heat insert versions...

    theta = atan(panel_thickness/panel_Z);
    panel_inner_offset = panel_thickness/sin(theta);
    screw_count = 3;

    // Truncation cutout
    difference()
    {
    rotate([0, 0, 0])
    translate([0, 0, dodeca_cut])
    difference()
    {
    show_inserts = true;
    hex_nut_slot = false;
    {
    difference()
    {
    difference()
    {
    scale(16) // WTF This was originally panel_radius, but then reduction of that fucked it up
    {
    if (power_variant)
    {
        Dodecahedron(0.1);
    } else
    {
        Dodecahedron(lower_dodeca);
    }
    }
    //translate([0, 0, -dodeca_cut + vertex_cutoff/2]) cube([10, 10, vertex_cutoff], center=true);
    }
    $fn=64;
    screw_offset = pcorner_dist + (power_variant ? pcorner_dist : 0.0);
    if (show_screw_holes)
    {
    for (i = [0:screw_count])
    {
        for (j = [0:secure])
        {
        union()
        {
        rotate([0, 0, -30+screw_count*10 + 360/screw_count*i])
        {
        // Due to the vertex connector being offset to the inner volume, the 'distance from corner' is calculated from the outside of the panels
        translate([secure*((j-0.5)*multi_secure_spacing*2), 0, 0.0])
        translate([0, 0, -dodeca_cut-panel_inner_offset])
        rotate([tetra_a, 0, 0])
        {
        translate([0, screw_offset, 0.28]) // .28 is an approximate value...
        {
            union()
            {
            cylinder(5, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
            BrassInsert();
            }
        }
        
        if (hex_nut_slot)
        {
        buffer = 0.5; // extra space for nut
        $fn=36;
        translate([0, 0, -2.8])
        union()
        {
        scale(0.1) rotate([0, 0, 0] ) cylinder(15, (5.5 + buffer)/2, (5.5 + buffer)/2);
        // little bit of push and pull space
        // this is just approximate, it's a little bigger than the brass insert
        scale([1.0, 1.0, 1.1]) BrassInsert();
        }
        }
        //translate([0, 0, -1.1])
        //scale(0.1) scale([1, 1, 3]) nut("M3");
        }
        }
        }
        }
    }
    }
    
    if (show_screw_holes && vertex_cutoff > 0.0)
    {
        translate([0, 0, dodeca_cut]) rotate([0, 180, 0]) cylinder(12, (    0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
    }
    
    if (!power_variant)
    {
        for (i = [0:3])
        {
            rotate([0, 0, 60+120*i])
            {
                translate([-5, 4, -5])
                cube([30,30,10]);
            }
        }
    }
    }
    }
    
    if (vertex_cutoff > 0.0 && show_screws)
    {
    rotate([0, 180, 0]) translate([0, 0, dodeca_cut-vertex_cutoff]) scale(0.1) screw("M3x30");
    }
    
    // TODO: Prefab variant with triangle hole for power coord
    if (power_variant)
    {
    $fn=100;
    //translate([0, 0, -0.0]) cylinder(5, 8, 8);
    translate([0, 0, -0])
    hull()
    {
        for (i=[0:3])
        {
            rotate([0, 0, 60+i*120]) translate([0, 4, -7]) cylinder(10, 1.0, 1.0);
        }
    }
    }
    }
    // Procedural truncation for babies, oldies, and hot math girls
    color([0, 1, 0, 0.5]) translate([0, 0, vertex_tehtra_height_truncation*0.5]) cube([100, 100, vertex_tehtra_height_truncation], center=true);
    }
}

module VertexPlatformDockNotch(sections=[1, 1, 1], clearance=0.0)
{
    translate([0, 0, 2.88386]) union()
    {
        $fn=64;
        hull()
        {
        scale([1.0, 1.0, 0.5]) sphere(0.6+clearance);
        rotate([0, 180, 0]) cylinder(1.5, 0.6+clearance , 0.4);
        }
    }
}

module VertexPlatformDockHole(sections=[1, 1, 1])
{
    translate([0, 0, 2.88386-0.15]) union()
    {
        $fn=64;
        // Clear platform for insertion path
        translate([0, 0, 0.4]) scale([1.0, 1.0, 1.3]) BrassInsert();
        BrassInsert();
        rotate([0, 180, 0]) cylinder(7, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
    }
}

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

module PlatformSection(radius, angles, fn)
{
    linear_extrude(12)
    Sector(radius, angles, fn);
}

module PiSections(slices)
{
    union()
    {
    if (slices[0])
    {
        color([0.5, 0.0, 1.0, 0.5])
        PlatformSection(12, [30, 150], 24);
    }
    if (slices[1])
    {
        color([1.0, 0.5, 1.0, 0.5])
        PlatformSection(12, [150, 270], 24);
    }
    if (slices[2])
    {
        color([1.0, 0.0, 0.0, 0.5])
        PlatformSection(12, [30, -90], 24);
    }
    }
}

module FastPowerVert()
{
translate([0, 0, -0.124])
import("beveled_power_vertex_connector.stl");
}

module VertexNotch(sections=[1, 1, 1], secure=0, vertex_cutoff = 0.0, show_screw_holes=true, show_screws=false, power_variant=false, rounded_variant=true)
{
    intersection()
    {
        PiSections(sections);
        //PiSections([0, 0, 1]);
        if (rounded_variant)
        {
            if (power_variant)
            {
                FastPowerVert();
            } else
            {
                VertexConnectorV2();
            }
        }
        else
        {
        VertexConnector(secure, vertex_cutoff, show_screw_holes, show_screws, power_variant);
        }
    }
}

//VertexConnector(0, 0);

//translate([0, 0, 0])
//hull()
//{
//    for (i=[0:3])
//    {
//        rotate([0, 0, 60+i*120]) translate([0, 4, 0]) cylinder(5, 1.0, 1.0);
//        rotate([0, 0, 60+i*120]) translate([0, 4, 5]) sphere(1.0);
//    }
//}

//scale(10) VertexNotch([1, 0, 0], secure=1, power_variant=false);


module BeveledVertexConnector(bevel_radius = 0.5, $fn = 24) {
    // 1. We use minkowski to round the edges
    minkowski() {
        // 2. Shrink the object slightly so the bevel 
        // doesn't make the connector too large to fit the panels
        VertexConnector(show_screw_holes=false, dodeca_cut = 0.88386, lower_dodeca=-0.05);
        
        // 3. This is the "brush" that creates the smoothness
        sphere(r = bevel_radius);
    }
}

//scale(10) VertexNotch([1, 1, 1], secure=0, power_variant=false);

module VertexConnectorScrewHoles(secure=0, vertex_cutoff = 0.0, show_screw_holes = true, show_screws=false, power_variant=false, dodeca_cut = 2.88386)
{

    secure =  (power_variant ? 1: secure);
    multi_secure_spacing = power_variant ? power_secure_spacing : standard_secure_spacing;
    // Nut hold vs heat insert versions...

    theta = atan(panel_thickness/panel_Z);
    panel_inner_offset = panel_thickness/sin(theta);
    screw_count = 3;
    

    rotate([0, 0, 0])
    translate([0, 0, dodeca_cut])
    difference()
    {
        show_inserts = true;
        hex_nut_slot = false;
        screw_offset = pcorner_dist + (power_variant ? pcorner_dist : 0.0);
    if (show_screw_holes)
    {
    for (i = [0:screw_count])
    {
        for (j = [0:secure])
        {
        union()
        {
        rotate([0, 0, -30+screw_count*10 + 360/screw_count*i])
        {
        // Due to the vertex connector being offset to the inner volume, the 'distance from corner' is calculated from the outside of the panels
        translate([secure*((j-0.5)*multi_secure_spacing*2), 0, 0.0])
        translate([0, 0, -dodeca_cut-panel_inner_offset])
        rotate([tetra_a, 0, 0])
        {
        // Power variant -0.3
        translate([0, screw_offset, 0.28-0.30]) // .28 is an approximate value...
        {
            union()
            {
            cylinder(15, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
            BrassInsert();
            translate([0, 0, 2]) scale(0.1) nutcatch_parallel("M3", 8.0);
            }
        }
        
        }
        }
        }
        }
    }
    }
    }
    }

    $fn=36*2;

// M8 rods for the structural frame to support cargo
module FrameRods(central_diplacement=25)
{
for (i = [0:2])
{
    rotate([0, -magic_angle, 30+120*i])
    // TODO: This should be calculated to fit a multiple of 10mm so that m8 rods
    // can be sourced in a correct size
    translate([central_diplacement, 0, 8])
    rotate([0, 90, 0]) cylinder(100, 4, 4);
}
}


module VertexConnectorV2()
{
//Dodecahedron();
// To render the smooth version:
scale(0.1)
rotate([0, 0, 0])
difference()
{
difference()
{
union()
{
color([1, 1, 0, 0.2]) translate([0, 0, 5.28+18.5]) scale(10) BeveledVertexConnector(bevel_radius = 0.3, $fn = 2*36);
//FrameRods();
}
union()
{
FrameRods();
translate([0, 0, 0]) cube([100, 100, vertex_tehtra_height_truncation*10*2], center=true);
translate([0, 0, 20.5+5.3+18.5]) scale(10) BeveledVertexConnector(bevel_radius = 0.3, $fn = 2*36);
}
}
union()
{
scale(10) VertexConnectorScrewHoles();
}
}
}


module VertexConnectorV2Top()
{

tri_extend = 2.5;
translate([0, 0, -tri_extend])
linear_extrude(tri_extend +vertex_tehtra_height_truncation)
{
projection()
{
scale(0.1)
rotate([0, 0, 0])
difference()
{
color([1, 1, 0, 0.2]) translate([0, 0, 5.28+18.5]) scale(10) BeveledVertexConnector(bevel_radius = 0.3, $fn = 2*36);
translate([0, 0, vertex_tehtra_height_truncation*10*2]) cube([100, 100, vertex_tehtra_height_truncation*10*2], center=true);
}
}
}
}


module VertexConnectorToTriangularPrism()
{
scale(10) rotate([0, 180, 0]) 
{
VertexConnectorV2();

union()
{
difference()
{
VertexConnectorV2Top();

rotate([-magic_angle*2, 0, 0])
translate([0, 51.1, 0])
cube(100, center=true);

// This is the cube that cuts off the bottom part of the triangular prism
// from the perspective of the ground flat plane
rotate([-magic_angle*2, 0, 0])
translate([0, 0, -7.2])
cube(12, center=true);
}
}
}
}



//translate([80, -10, 0])
//sphere(60);
//translate([0, 0, -200])
//MountingInterface();

//MountingInterface();

//VertexConnector(power_variant=true);

// Power Variant Beveled Vertex Connector
// Note: Ensure your include files (dodecahedroid_config.scad, etc.) are in the same folder.

module BeveledPowerVertexConnector(bevel_radius = 0.3) {
    // 1. Move everything to a consistent scale
    difference() {
        // MAIN BODY
        minkowski() {
            // We use the base power variant but slightly undersized for the bevel
            VertexConnector(
                power_variant = true, 
                show_screw_holes = false, 
                dodeca_cut = 2.88386 + 0.5, 
                lower_dodeca = 0.0
            );
            $fn = 4; // Keep fn lower for minkowski to avoid long render times
            sphere(r = bevel_radius);
        }

        // 2. SCREW HOLES & INSERTS
        // Explicitly calling the holes at the same scale as the body
        VertexConnectorScrewHoles(power_variant = true, secure = 1);

        // 3. POWER PASSTHROUGH
        // Re-cutting the center hull to ensure the minkowski didn't "fill" it
        $fn = 12;
        hull() {
            for (i = [0:2]) {
                rotate([0, 0, 60 + i * 120]) 
                translate([0, 4, -10]) 
                cylinder(h = 30, r = 1.2, center = true);
            }
        }

        // 4. ARTIFACT REMOVAL (The "Bottom Flatten")
        // This cuts off the rounded "minkowski bowl" at the bottom
        // Adjust the '2.8' value to match your desired floor height
        translate([0, 0, -5 + 2.88386]) 
            cube([50, 50, 10], center = true);
    }
}

//VertexConnectorScrewHoles(power_variant = false, secure = 0);
// Render
//BeveledPowerVertexConnector(bevel_radius = 0.3);

//translate([0, 0, 0]) VertexConnector(power_variant=false);

// translate([0, 0, 0])
// Dodecahedron(0.1);