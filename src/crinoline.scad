include <dodecahedroid_config.scad>

$fn=32;

module RoundTri(rad=1, corner_rad=1, height = 1)
{
    linear_extrude(height)
    {
    hull()
    {
    translate([sin(0)*rad, cos(0)*rad, 0]) circle(corner_rad);
    translate([sin(120)*rad, cos(120)*rad, 0]) circle(corner_rad);
    translate([sin(240)*rad, cos(240)*rad, 0]) circle(corner_rad);
    }
    }
}

dodecahedron_radius = 1/.688 * panel_radius;

//module TelescopingShell()
//{
//    difference()
//    {
//        RoundTri(3, 1, 35*3);
//        translate([0, 0, -0.05]) RoundTri(2.2, 0.7, 35*3 + 0.1);
//    }
//}

module Torus(R=100, r=1) {
    rotate_extrude(convexity = 10)
        translate([R, 0, 0]) 
        circle(r);        
}

module Crinoline()
{
    // --- Editable Settings ---
    hoop_count = 12;           
    hoop_thickness = 0.1; // 2mm radius
    total_height = 75;        
    
    bottom_radius = dodecahedron_radius+2;        // Wide base
    top_radius = 16;//dodecahedron_radius/2;           // Narrow top
    
    // CURVE CONTROL: 
    // 1.0 = Linear (Cone)
    // > 1.0 = Arcosanti Bell (Narrows quickly at top, flares at bottom)
    // < 1.0 = Bulbous/Dome shape
    curve_factor = 3.5; 

    for (i = [0 : hoop_count - 1]) {
        // Normalize height from 0 to 1
        h_ratio = i / (hoop_count - 1); 
        
        // Vertical position
        z_pos = h_ratio * total_height;
        
        // Use a power function to interpolate the radius
        // This creates the "bell" flare.
        t = pow(h_ratio, curve_factor);
        
        // Calculate radius: we interpolate from BOTTOM to TOP
        // At h_ratio 0 (bottom), current_R = bottom_radius
        // At h_ratio 1 (top), current_R = top_radius
        current_R = bottom_radius + (top_radius - bottom_radius) * t;
        
        if (i < 8)
        {
            color([0.5, 0.5, 0.5, 0.5])
            translate([0, 0, z_pos])
                Torus(R = current_R, r = hoop_thickness);
        } else
        {
            color([1, 1, 0, 1])
            translate([0, 0, z_pos])
                Torus(R = current_R, r = hoop_thickness);
        }
    }
}

module CurvedShell(thickness = 1.0, slices = 60)
{
    // --- Inherited Settings from your script ---
    hoop_count = 12; // Used here for vertical smoothness
    total_height = 75;
    bottom_radius = dodecahedron_radius + 2;
    top_radius = 16;
    curve_factor = 3.5;

    // Generate the 2D profile for the wall
    // We create a series of points for the outer curve, then the inner curve
    profile_points = concat(
        // Outer Wall (Bottom to Top)
        [for (i = [0 : slices]) 
            let (h_ratio = i / slices)
            let (t = pow(h_ratio, curve_factor))
            let (r = bottom_radius + (top_radius - bottom_radius) * t)
            [r, h_ratio * total_height]
        ],
        // Inner Wall (Top back to Bottom)
//        [for (i = [slices : -1 : 0]) 
//            let (h_ratio = i / slices)
//            let (t = pow(h_ratio, curve_factor))
//            let (r = (bottom_radius + (top_radius - bottom_radius) * t) - thickness)
//            [r, h_ratio * total_height]
//        ]
    );

    rotate_extrude(convexity = 10, $fn = 64) {
        polygon(profile_points);
    }
}

//CurvedShell();

module ThinCurvedShell(slices = 60)
{
    total_height = 75;
    bottom_radius = 40; 
    top_radius = 16;
    curve_factor = 3.5;

    // Generate only the single-line profile
    profile_points = [
        for (i = [0 : slices]) 
            let (h_ratio = i / slices)
            let (t = pow(h_ratio, curve_factor))
            let (r = bottom_radius + (top_radius - bottom_radius) * t)
            [r, h_ratio * total_height]
    ];

    // To get a non-solid mesh, we use a very tiny thickness 
    // OR we use the 'polygon' with only the curve and a return to the axis
    // However, the best way for a "shell" is to create a very thin offset.
    
    // If you truly want a single-skin mesh for Blender:
    rotate_extrude(convexity = 10, $fn = 64) {
        // We create a line with a negligible width (0.01) 
        // because OpenSCAD cannot render a 0-width polygon.
        offset(delta = 0.01) {
            for (i = [0 : len(profile_points)-2]) {
                line(profile_points[i], profile_points[i+1]);
            }
        }
    }
}

module line(start, end) {
    hull() {
        translate(start) circle(0.001);
        translate(end) circle(0.001);
    }
}

ThinCurvedShell();

//Crinoline();

//translate([0, 0, dodecahedron_radius])
//color([0.5, 0.5, 0.5, 0.5])
//sphere(dodecahedron_radius);