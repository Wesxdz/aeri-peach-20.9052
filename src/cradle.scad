// For evaluating cradle vertex connector power variant

include <dodecahedroid_config.scad>
include <wheel_panel.scad>

include <BOSL2/std.scad>
include <BOSL2/gears.scad>

module Cradle()
{
// Export
//translate([0, 0, 209])
//scale(10)
rotate([0, -tetra_a, 180])
rotate([0, 0, -30-120-120])
//rotate([0, 0, -30])

union()
{
color([0.3, 0.3, 0.4, 1]) translate([0, 0, -260/10])
scale(0.1) import("vertex_connector_power_variant_mm.stl");

rotate([0, 0, 30])
difference()
{
rotate([0, 0, -30])
difference()
{
$fn=128;
    rotate([-magic_angle, 0, 0])
    {
        for (i = [0 : len(pos)-1]) {
            if (face_groups[i] == 3)
            {
            translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
            {
                show_cradle_vent = false;
                show_mounts = true;
                if (i == 4)
                {
                    import ("wheel_panel_2.stl");
                    // WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1, 1]), show_mounts , show_rest=false, 2);
                }
                
                if (i == 11) 
                {
                    import ("wheel_panel_3.stl");
                    // WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1, 1]), show_mounts , show_rest=false, 3);
                }
                
                if (i == 9) 
                {
                    import ("wheel_panel_1.stl");
                    // WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1, 1]), true, show_rest=false, 1);
                    translate([0, 0, -7]) scale(0.1) import("omniball.stl");
                }
                }
                
            }
        }
    }
    
    // TODO: Calculate the exact Y intersection
    translate([0, 0, -29.1])
    //translate([0, 0, tan(90-magic_angle)*5])
    // translate([0, 0, -26.3564)
    union()
    {
    cylinder(5, 8, 8);
    hull()
    {
        for (i=[0:3])
        {
            rotate([0, 0, 60+i*120]) translate([0, 4, 0]) cylinder(10, 1.0, 1.0);
            //rotate([0, 0, 60+i*120]) translate([0, 4, 5]) sphere(1.0);
        }
    }
    }
}
$fn=100;
    scale([1, 1, 1])
    translate([0, 0, -29.1])
    hull()
    {
        for (i=[0:3])
        {
            rotate([0, 0, 30+i*120]) translate([0, 4, 0]) cylinder(10, 1.0, 1.0);
            //rotate([0, 0, 60+i*120]) translate([0, 4, 5]) sphere(1.0);
        }
    }
}
}
}

rotate([0, -tetra_a, 0])
{

translate([0, 0, 20.9443])
{
Cradle();
}
}

//color([0.5, 0.5, 0.5, 0.5]) import("bottom_connectors.stl");