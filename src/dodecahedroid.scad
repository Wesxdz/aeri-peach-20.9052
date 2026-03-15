// Giant Peach 20.9052
include <dodecahedroid_config.scad>

include <pentagon_plate.scad>
include <connector_pentagon_plate.scad>
include <fan_panel.scad>
include <wheel_panel.scad>
include <custom_plate.scad>

include <peach_panel.scad>
include <cargo_bay_hatch.scad>

//include <mp_vc_flat.scad>

include <core_platform.scad>
include <camera_panel.scad>
// include <atx_compliance.scad>
// include <vertex_composite.scad>
//include <penta_composite.scad>

//if (true)
//{
//rotate([0, 90+magic_angle, 90])
//translate([-0.5-atx_board_depth , -atx_board_height/2, -16])
//{
//ATXMotherboardMount();
//rotate([0, -90, 0]) ATXSpecification();
//}

//
// TODO: How to mount the PSU to the base?
// rotate([0, 0, 360/6])
//translate([-7, -7, -16.9118+0.5])
//color([.0, 0.5, 1.0, .5])
//PSUVolume();
//}

dodecahedron_radius = 1/.688 * panel_radius;

show_cradle_vent = true;
scale(10)
rotate([-tetra_a, 0, 0])
rotate([0, 0, 120])
rotate([0, 180, 180])
difference()
{
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) {
    //if (face_groups[i] == 0)
    if (i == 0)
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    CradlePanel();
    }
    if (false)
    //if(face_groups[i] == 3)
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    if (!render_fast_iter)
    {        
        if (i == 1)
        {
        // CustomPentagonPlate
            //PentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], "sorceress_vent.svg");
            rotate([0, 0, -72*2]) 
            {
            CameraPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge);
            //CameraPlateScrews();
//            CameraPentagonPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i]);
//            rotate([180, 0, 36]) translate([-10, 0, -panel_thickness-1]) Camera(0.7);
            }
        }
        // TODO: Refactor sections to distinct files...
        else if (i == 4) 
        {
            WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1]), true, show_rest=false, 2);
        }
        else if (i == 11) 
        {
            //WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1]), true, show_rest=false, 3);
        }
        else if (i == 9) 
        {
            
            WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, show_cradle_vent, color([0, 1, 1]), true, show_rest=false, 1);
        }
       else if (i == 6)
        {
            //PeachPanel();
            PeachCorePanel();
//            FleshBleed();
//            rotate([0, 180, -18]) translate([0, 0, -0.83])
//            KeycapAttachment();
//            CoreVolume();
            // FleshBleed();
            //CoreVolume();
        } 
        else if (i == 5)
        {
            FanPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)], 36);
        } else if (i == 7)
        {
            FanPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)], 36*2+18);
        }
        else if (i == 3 || i == 10)
        {
            ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)], m3_distance_from_panel_corner, [4, 4, 4, 4, 4], [0, 1, 0, 1, 0]);
        }
        else
        {
        //ConnectorPentagonPlateScrews(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)]);
        if (i != 8)
        {
            //color(unique_panel_colors[i%len(unique_panel_colors)])
            ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], unique_panel_colors[i%len(unique_panel_colors)]);
            }
            if (i == 8)
            {
                //RightHatch();
                //LeftHatch();
            }
        }
    }
    else
    {
        if (i == 4 || i == 11 || i == 9)
        {
            // WheelMountPrefab
            WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true);
        } else
        {

            //PentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vents[i], [0.0, 1.0, 1.0, 0.1]);
        }
    }
    }
    }
}
translate([0, 0, -29.2]) cylinder(5, 8, 8);
translate([0, 0, -29.5])
hull()
{
    for (i=[0:3])
    {
        rotate([0, 0, 60+i*120]) translate([0, 4, 0]) cylinder(5, 1.0, 1.0);
        rotate([0, 0, 60+i*120]) translate([0, 4, 5]) sphere(1.0);
    }
}

// Cutout top passthrough circle
cylinder(100, 4.2, 4.2);
}
//
//import("baby_platform.stl");
//import("mother_platform_full.stl");
//import("mother_platform_front.stl");

//import("mothership_connectors.stl");
//import ("escape_pod_connectors.stl");