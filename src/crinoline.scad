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
    hoop_count = 13;           
    hoop_thickness = 0.2; // 2mm radius
    total_height = 100;        
    
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
        
        translate([0, 0, z_pos])
            Torus(R = current_R, r = hoop_thickness);
    }
}

//Crinoline();

//translate([0, 0, dodecahedron_radius])
//color([0.5, 0.5, 0.5, 0.5])
//sphere(dodecahedron_radius);