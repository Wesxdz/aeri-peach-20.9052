include <nutsnbolts/cyl_head_bolt.scad>
include <pentagon_plate.scad>

module place_screw_support(base_radius, support_radi, thickness) {
    sides = 5;
    angles = [for (i = [0:sides-1]) i*(360/sides)];
    base_coords = [for (th=angles) [base_radius*cos(th), base_radius*sin(th), 0]];
    for (i = [0:len(base_coords)-1])
    {
        translate(base_coords[i]) cylinder(thickness, support_radi[i], support_radi[i]);
    }
}

module place_screw_holes(base_radius, distances_from_corners, thickness, secure, secure_spacing) {
    sides = 5;
    angles = [for (i = [0:sides-1]) i*(360/sides)];
    base_coords = [for (th=[0:sides-1]) [(base_radius+((0.3+screw_clearance)/2) - distances_from_corners[th])*cos(angles[th]), (base_radius+((0.3+screw_clearance)/2) - distances_from_corners[th])*sin(angles[th]), 0]];
    for (i = [0:len(base_coords)-1])
    {
        if (secure[i])
        {
            // bottom (inside)
            translate(base_coords[i]) translate([sin(36+72*(2-i))*secure_spacing[i], cos(36+72*(2-i))*secure_spacing[i], 0]) rotate([0, 180, 0]) cylinder(10, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
            // top
            translate(base_coords[i]) translate([sin(36+72*(2-i))*-secure_spacing[i], cos(36+72*(2-i))*-secure_spacing[i], 0]) rotate([0, 180, 0]) cylinder(10, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
        }
        else
        {
            translate(base_coords[i]) rotate([0, 180, 0]) cylinder(10, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
        }
    }
}

module place_connector_screws(base_radius, distances_from_corners, thickness, secure, secure_spacing) {
$fn=32;
    sides = 5;
    angles = [for (i = [0:sides-1]) i*(360/sides)];
    base_coords = [for (th=[0:sides-1]) [(base_radius+((0.3+screw_clearance)/2) - distances_from_corners[th])*cos(angles[th]), (base_radius+((0.3+screw_clearance)/2) - distances_from_corners[th])*sin(angles[th]), 0]];
    for (i = [0:len(base_coords)-1])
    {
        if (secure[i])
        {
            // bottom (inside)
            translate(base_coords[i]) translate([sin(36+72*(2-i))*secure_spacing[i], cos(36+72*(2-i))*secure_spacing[i], 0]) rotate([0, 180, 0]) scale(0.1) screw("M3x12");
            // top
            translate(base_coords[i]) translate([sin(36+72*(2-i))*-secure_spacing[i], cos(36+72*(2-i))*-secure_spacing[i], 0]) rotate([0, 180, 0]) scale(0.1) screw("M3x12");
        }
        else
        {
            translate(base_coords[i]) rotate([0, 180, 0]) scale(0.1) screw("M3x12");
        }
    }
}

module ConnectorPentagonPlateScrews(radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color, distances_from_corners=m3_distance_from_panel_corner, support_radi=[4, 4, 4, 4, 4]) 
{
    Z = panel_thickness/tan(116.565/2);
    top_radius = radius-Z;
    place_connector_screws(top_radius, distances_from_corners, thickness);
}


module ConnectorPentagonPlate(radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color, distances_from_corners=m3_distance_from_panel_corner, support_radi=[4, 4, 4, 4, 4], secure=[0, 0, 0, 0, 0], secure_spacing=[standard_secure_spacing, standard_secure_spacing, standard_secure_spacing, standard_secure_spacing, standard_secure_spacing]) {

    Z = panel_thickness/tan(116.565/2);
    top_radius = radius-Z;
    difference()
    {
    union()
    {
    PentagonPlate(radius, cell_size, wall_thickness, thickness, border_edge, vent, render_color);
    intersection()
    {
    place_screw_support(top_radius, support_radi, thickness);
    PentagonPlate(radius, cell_size, wall_thickness, thickness, border_edge, false);
    }
    }
    $fn=36;
    // The screw holes are placed relative to 'top radius' ie the smaller pentagon of the chamfer
    // this is so they line up with the vertex connector
    translate([0, 0, 1]) place_screw_holes(top_radius, distances_from_corners, thickness, secure, secure_spacing);
    }
    //place_connector_screws(top_radius, distances_from_corners, thickness, secure, secure_spacing);
  }
  
module DecagonCut(mult)
{
    for (i = [0:4])
    {
        
        //mult = (i == 0) ? 1.6 : 1.0;
        rotate([0, 0, i*(360/5)])
        translate([panel_radius*2-pentagon_point_truncation * mult[i], 0, 0]) 
        {
        hull()
        {
        trunc_cut = tan(90-tetra_a)*panel_thickness*2;
        cube([panel_radius*2+trunc_cut, panel_radius*2+trunc_cut, 0.001], center=true);
        translate([0, 0, panel_thickness]) cube([panel_radius*2, panel_radius*2, 0.001], center=true);
        }
        }
    }
}


module DecagonSupportCut(mult)
{
    for (i = [0:4])
    {
        
        //mult = (i == 0) ? 1.6 : 1.0;
        rotate([0, 0, i*(360/5)])
        translate([panel_radius*2-pentagon_point_truncation * mult[i], 0, 0]) 
        {
        hull()
        {
        $fn=36*2;
        translate([0, 0, panel_thickness]) cylinder(panel_thickness, panel_radius/3, panel_radius/3);
        }
        }
    }
}
 
// panel_cutout is the radius of the circular cutout from the panel center
module TruncatedPlate(panel_cutout = panel_radius-4, distances_from_corners, secure_spacing, mult = [1.0, 1.0, 1.0, 1.0, 1.0])
{
    Z = panel_thickness/tan(116.565/2);
    top_radius = panel_radius-Z;
difference()
{
union()
{
// secure_spacing 3.5 is NOSE CONE SPACING
ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff", secure=[1, 0, 0, 0, 0], distances_from_corners=distances_from_corners, secure_spacing=secure_spacing);

}
union() {
//translate([12, 0, 0,])
//cylinder(panel_height, 6, panel_cutout);

// Nose Cone variant
//translate([16, 0, 0,])
//cylinder(panel_height, 10, panel_cutout);
 DecagonCut(mult);
}
}
}

module NeoNoseConePanel()
{
TruncatedPlate(0.0, distances_from_corners = [6, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[3.5, 0, 0, 0, 0], mult = [1.6, 1, 1, 1, 1]);
}

module NeoCradlePanel()
{
TruncatedPlate(0.0, distances_from_corners = [6, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[1.75, 0, 0, 0, 0], mult = [1.6, 1, 1, 1, 1]);
}

//TruncatedPlate();
panel_cutout = panel_radius-4;

//$fn=36*4;
//projection(cut=true)
//color([0, 1, 1, 0.9]) cylinder(panel_thickness, panel_cutout, panel_cutout);

module PolycarbonateSupportPanel()
{
$fn=36*2;
difference()
{
TruncatedPlate(0.0, distances_from_corners = [pcorner_dist, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[0, 0, 0, 0, 0]);
cylinder(panel_thickness, panel_cutout+0.08, panel_cutout+0.09); // 1.8 mm pad snug
}
difference()
{
translate([0, 0, panel_thickness])
difference()
{
cylinder(panel_thickness, panel_cutout+0.7, panel_cutout+0.5);
cylinder(panel_thickness, panel_cutout-0.5, panel_cutout-0.5);
}
DecagonSupportCut([9.0, 9.0, 9.0, 9.0, 9.0]);
}
}

// A reusable module for slanted support chunks
module trapezoid_chunk(base_width, top_width, height, thickness) {
    hull() {
        // Bottom face
        translate([0, -base_width/2, 0])
        cube([thickness, base_width, 0.01]);

        // Top face
        translate([0, -top_width/2, height])
        cube([thickness, top_width, 0.01]);
    }
}

module UpperDINSupportChunk()
{
    // Local constants for easier adjustment
    base_w = 4;
    base_t_w = base_w+1;
    top_w = 9;
    thickness = 2.5;
    base_cube_height = 0.8
    ;
    trap_height = 2.81;

    // Position the whole assembly
    translate([-panel_radius + pcorner_dist, 0, panel_thickness * 2]) 
    {
        // 1. The Cube "Base" (matches the narrow bottom of the trapezoid)
        // translate([0, -base_w/2, 0])
        // cube([thickness, base_w, base_cube_height]);

        // 2. The Trapezoid Part (flaring out from 5 to 10)
        translate([0, 0, base_cube_height])
        trapezoid_chunk(base_t_w, top_w, trap_height, thickness);
    }
}

//PolycarbonateSupportPanel();
//UpperDINSupportChunk();



//TruncatedPlate(0.0, distances_from_corners = [pcorner_dist, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[0, 0, 0, 0, 0]);
//scale(10) PolycarbonateSupportPanel();
//NeoCradlePanel();


//DecagonSupportCut([2.4, 1.0, 1.0, 1.0, 1.0]);
// Inkscape is a better bet for exporting to DXF 
// for SendCutSend, but use mm



//translate([0, 0, 1]) scale(0.1) import("neo_cradle_panel.stl");
//NeoCradlePanel();
//ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff");
//ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true, color([0, 1, 1, 1]), [3, 3, 6, 3, 3], [4, 4, 19, 4, 4], [0, 0, 1, 0, 0], [0, 0, power_secure_spacing, 0, 0]);
//ConnectorPentagonPlateScrews(panel_radius, 0.3, 0.1, panel_thickness, border_edge, false, color([0, 1, 1, 1]));