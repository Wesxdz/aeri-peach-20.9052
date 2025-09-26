include <dodecahedroid_config.scad>
include <pentagon_plate.scad>
include <connector_pentagon_plate.scad>

include <ergonomic_handle_v5.scad>

module Fan(size = 14.0, mount_offset = 0.15)
{   

    difference() {
        translate([0, 0, 1.35]) cube([size, size, 2.5], center=true);
        mount_hole_radius = (0.5+screw_clearance)/2;
        FanMount(size, mount_offset, 100, mount_hole_radius);
    }
}

module FanMount(size = 7.0, mount_offset = 1.5, height, hole_radius)
{
        $fn=32;
        union()
        {
        
        translate([-size+mount_offset/2, -size+mount_offset/2, 0]) cylinder(height, hole_radius, hole_radius, center=true);
        translate([-size+mount_offset/2, size-mount_offset/2, 0]) cylinder(height, hole_radius, hole_radius, center=true);
        translate([size-mount_offset/2, size-mount_offset/2, 0]) cylinder(height, hole_radius, hole_radius, center=true);
        translate([size-mount_offset/2, -size+mount_offset/2, 0]) cylinder(height, hole_radius, hole_radius, center=true);
        }
}

module FanPanel(radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color, fan_rot=0.0, show_fan=false) {
    difference()
    {
    union()
    {
    difference()
    {
    mount_hole_radius = (0.5+screw_clearance)/2;
    union()
    {
    ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vent, render_color, m3_distance_from_panel_corner, [4, 4, 4, 4, 4], [0, 0, 0, 1, 1]);
    // Right Variant
    // [0, 0, 0, 1, 1]
    
    // Left Variant
    // [0, 0, 1, 1, 0]
    translate([0, 0, panel_thickness/2]) rotate([0, 0, fan_rot]) FanMount(7.0, 1.5, panel_thickness, 0.8);
    }
    rotate([0, 0, fan_rot]) FanMount(7.0, 1.5, 100, mount_hole_radius);
    }
    if (show_fan)
    {
    rotate([0, 0, fan_rot]) Fan(14.0);
    }
    // Area around ventilation...
    }
    
    //scale(0.1) rotate([90,0,0]) ergonomic_handle(hand_length=178, hand_width=79.4, fingergroove=false);
    
//    // Simple handle cutout...
//    handle_radius = 0.8;
//    // TODO: This should be calculated relative to pentagon radius
//    handle_dist_out = 11;
//    hull()
//    {
//        rotate([0, 0, 36-72]) 
//        {
//            translate([handle_dist_out, 5, 0]) cylinder(panel_thickness, handle_radius, handle_radius, $fn=64);
//            translate([handle_dist_out, -3, 0]) cylinder(panel_thickness, handle_radius, handle_radius, $fn=64);
//            }
//    }
    }
}

// linear_extrude(panel_thickness) 
//projection() mirror([1, 0, 0]) rotate([-90,0,0]) ergonomic_handle(hand_length=178, hand_width=79.4, fingergroove=false);


//FanPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, unique_panel_colors[i%len(unique_panel_colors)], 36);