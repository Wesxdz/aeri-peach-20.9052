// Dodecahedron

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

module VertexConnector(secure=0, vertex_cutoff = 0.0, show_screw_holes = true, show_screws=false, power_variant=true)
{

    secure =  (power_variant ? 1: secure);
    multi_secure_spacing = power_variant ? power_secure_spacing : standard_secure_spacing;
    // Nut hold vs heat insert versions...

    theta = atan(panel_thickness/panel_Z);
    panel_inner_offset = panel_thickness/sin(theta);
    screw_count = 3;
    
    dodeca_cut = 2.88386;

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
    scale(panel_radius)
    {
    if (power_variant)
    {
        Dodecahedron(0.1);
    } else
    {
        Dodecahedron();
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
    
    // TODO: Procedural truncation for babies and oldies
    
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

module VertexNotch(sections=[1, 1, 1], secure=0, vertex_cutoff = 0.0, show_screw_holes=true, show_screws=false, power_variant=false)
{
    intersection()
    {
        PiSections(sections);
        //PiSections([0, 0, 1]);
        VertexConnector(secure, vertex_cutoff, show_screw_holes, show_screws, power_variant);
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
//scale(10) VertexNotch([0, 1, 1], secure=0, power_variant=false);