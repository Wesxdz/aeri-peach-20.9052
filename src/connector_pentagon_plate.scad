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
  
module TrucatedPlate()
//{
difference()
{

// ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff");
union()
{
// ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff", secure=[1, 0, 0, 0, 0], distances_from_corners = [5.75, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[1.75, 0, 0, 0, 0]);
ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff", secure=[1, 0, 0, 0, 0], distances_from_corners = [5.0, pcorner_dist, pcorner_dist, pcorner_dist , pcorner_dist], secure_spacing=[3.5, 0, 0, 0, 0]);

}
panel_cutout = panel_radius-4;
difference() {
cylinder(panel_height, panel_cutout, panel_cutout);
//translate([12, 0, 0,])
//cylinder(panel_height, 6, panel_cutout);
translate([16, 0, 0,])
cylinder(panel_height, 10, panel_cutout);
}
    for (i = [0:5])
    {
        mult = (i == 0) ? 1.6 : 1.0;
        rotate([0, 0, i*(360/5)])
        translate([panel_radius*2-pentagon_point_truncation* mult, 0, 0]) 
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
//$fn=36*2;  
module CradlePanel()
{
TrucatedPlate();
}
//ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, "#ffffff");
//ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true, color([0, 1, 1, 1]), [3, 3, 6, 3, 3], [4, 4, 19, 4, 4], [0, 0, 1, 0, 0], [0, 0, power_secure_spacing, 0, 0]);
//ConnectorPentagonPlateScrews(panel_radius, 0.3, 0.1, panel_thickness, border_edge, false, color([0, 1, 1, 1]));