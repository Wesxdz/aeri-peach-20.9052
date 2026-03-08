include <dodecahedroid_config.scad>
include <nutsnbolts/cyl_head_bolt.scad>

// Constants
C0 = 0.809016994374947424102293417183;
C1 = 1.30901699437494742410229341718;

module Dodecahedron_Grounded() {
    points = [
        [ 0.0,  0.5,   C1], [ 0.0,  0.5,  -C1], [ 0.0, -0.5,   C1], [ 0.0, -0.5,  -C1],
        [  C1,  0.0,  0.5], [  C1,  0.0, -0.5], [ -C1,  0.0,  0.5], [ -C1,  0.0, -0.5],
        [ 0.5,   C1,  0.0], [ 0.5,  -C1,  0.0], [-0.5,   C1,  0.0], [-0.5,  -C1,  0.0],
        [  C0,   C0,   C0], [  C0,   C0,  -C0], [  C0,  -C0,   C0], [  C0,  -C0,  -C0],
        [ -C0,   C0,   C0], [ -C0,   C0,  -C0], [ -C0,  -C0,   C0], [ -C0,  -C0,  -C0]
    ];

    faces = [
        [ 12,  4, 14,  2,  0], [ 16, 10,  8, 12,  0], [  2, 18,  6, 16,  0],
        [ 17, 10, 16,  6,  7], [ 19,  3,  1, 17,  7], [  6, 18, 11, 19,  7],
        [ 15,  3, 19, 11,  9], [ 14,  4,  5, 15,  9], [ 11, 18,  2, 14,  9],
        [  8, 10, 17,  1, 13], [  5,  4, 12,  8, 13], [  1,  3, 15,  5, 13]
    ];

    // Calculate the exact Z-drop of the lowest vertex [0, 0.5, -C1]
    z_drop = -(0.5 * sin(magic_angle)) + (-C1 * cos(magic_angle));
    z_offset = abs(z_drop);
    
    translate([0, 0, z_offset]) 
        rotate([magic_angle, 0, 0]) 
            polyhedron(points, faces);
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

module PlatformSection(radius, angles, fn)
{
    linear_extrude(12)
    Sector(radius, angles, fn);
}

module VertexConnectorSimple(height=0.2)
{
    intersection()
    {
        cylinder(height, 100, 100);
        scale(100) Dodecahedron_Grounded();
    }
}

module VertexConnector(height=0.2, rounding=0.2, truncate=0.03, prism_radius = 0.02, vertex_cut=2.5) 
{
    // The main translate for the whole part
    translate([0, 0, rounding])
    minkowski() {
        // We do the subtraction INSIDE the minkowski to round the resulting edges
        difference() {
            intersection() {
                // Shrink height by rounding for minkowski expansion
                translate([0, 0, truncate]) 
                    cylinder(height - rounding*2, 100, 100);
                
                difference() {
                    scale(100) Dodecahedron_Grounded();
                    
                    // Center prism (also shrunk slightly for rounding)
                    rotate([0, 0, 90])
                    cylinder(h = height * 4, r = prism_radius - rounding, $fn = 3, center=true);
                }
            }

            // --- ROUNDED VERTEX CUTS ---
            vert_height = 1.5 + vertex_tehtra_height_truncation;
            pentagon_slide_x = vert_height / tan(magic_angle);
            
            for (i = [0:2]) {
                rotate([0, 0, 120 * i]) {
                    // We move the cube OUTWARD by the 'rounding' amount 
                    // so the minkowski expansion puts the flat face exactly where you want it.
                    translate([-15, (pentagon_slide_x - vertex_cut) + rounding, -5])
                        cube([30, 30, 10]);
                }
            }
        }
        // This rounds every intersection and edge created in the difference above
        sphere(r=rounding, $fn=32);
    }
}


module VertexConnectorScrewHoles(secure=0, power_variant=false, rounding=0.0, pent_h = pcorner_dist)
{
    secure =  (power_variant ? 1: secure);
    multi_secure_spacing = power_variant ? power_secure_spacing : standard_secure_spacing;

    theta = atan(panel_thickness/panel_Z);
    panel_inner_offset = panel_thickness/sin(theta);
    screw_count = 3;
    
    difference()
    {
        show_inserts = true;
        hex_nut_slot = false;
        //screw_offset = pcorner_dist + (power_variant ? pcorner_dist : 0.0);

    for (i = [0:screw_count])
    {
        // Pentagon panel slide distance (hypotenuse)
        pentagon_slide_x = sin((90-tetra_a))*pent_h;
        pentagon_slide_z = cos((90-tetra_a))*pent_h;
        
        rounding_z_lift = cos((90-tetra_a))*rounding;
        
        for (j = [0:secure])
        {
        union()
        {
        rotate([0, 0, screw_count*10 + 360/screw_count*i])
        // Due to the vertex connector being offset to the inner volume, the 'distance from corner' is calculated from the outside of the panels
        translate([pentagon_slide_x, 0, pentagon_slide_z-rounding_z_lift-panel_inner_offset]) // -panel_inner_offset+
        rotate([0, -(tetra_a), 0])
        translate([0, 0, -0.001])
        echo(-(90-tetra_a))
        {

        translate([secure*((j-0.5)*multi_secure_spacing*2), 0, 0.0])
            union()
            {
            cylinder(15, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
            BrassInsert();
            // TODO: Make nutcatch displacement procedural...
            translate([0, 0, 2.5]) scale(0.1) nutcatch_parallel("M3", 8.0);
            }
        }
        }
        }
    }
    }
}

module FrameRods(central_diplacement=25)
{
scale(0.1)
for (i = [0:2])
{
    rotate([0, -magic_angle, -30+120*i])
    // TODO: This should be calculated to fit a multiple of 10mm so that m8 rods
    // can be sourced in a correct size
    translate([central_diplacement, 0, 8])
    rotate([0, 90, 0]) cylinder(100, 4, 4);
}
}

//$fn=36;
module VertexStructure(height = 1.5, rounding = 0.2, truncate=vertex_tehtra_height_truncation, prism_radius = 0.0, vertex_cut=2.5, pent_h=pcorner_dist)
{
difference()
{
VertexConnector(height, rounding, truncate, prism_radius, vertex_cut);
union()
{
VertexConnectorScrewHoles(rounding=rounding, pent_h=pent_h);
FrameRods();
}
}
}

//VertexStructure();

//Vertex(height = 0.4, rounding = 0.001, truncate=0.0, prism_radius = 0.03);

