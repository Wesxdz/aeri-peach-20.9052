
include <dodecahedroid_config.scad>
include <wheel_mount.scad>
include <connector_pentagon_plate.scad>
include <bracket_anchor.scad>

module CradleRest()
{   
    // Attachment to wheel mount
    color([1.0, 0.0, 1.0, 0.75]) translate([0, bracket_start+insert_width, panel_thickness]) rotate([90, 0, 0]) linear_extrude((insert_width+bracket_start)*2) polygon([[0, 0], [0, bracket_height], [bracket_height/tan(tetra_a), 0]]);
}

module WheelMountPrefab(rotation, radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color)
{
mounted_wheel_depth = 0.8 + .002;
translate([0, 0, 0])
{
    translate([-wmb_pio, 0, -back_panel_to_wheel_center+0.5+panel_thickness*1.65]) rotate([-90, 0, -90]) 
    MountedWheel(mounted_wheel_depth);
}
}


module WheelMountSlots(wheel_config)
{
    mounted_wheel_depth = 0.8 + .002;
    front_wheel_shift = 0;
    // There are four wheel slot configurations

    // 1. Static stable

    // Wheel mount insert
    // wheel mount top width is 12
    for (i= [0 : 0])
    {
        if (wheel_config != 1)
        {
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -bracket_start-insert_width, 0]) 
        {
        cube([mounted_wheel_depth, insert_width, 1]);
        $fn=36;
        translate([mounted_wheel_depth+1.4, insert_width-1, .4]) scale(0.1) screw("M6x16");
        
        translate([0, insert_width-1-.3, panel_thickness-t_slot_cut_depth]) cube([4, 0.6, t_slot_cut_depth]);
        }
        
        mirror([0, 1, 0])
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -bracket_start-insert_width, 0]) 
        {
        cube([mounted_wheel_depth, insert_width, 1]);
        $fn=36;
        translate([mounted_wheel_depth+1.4, insert_width-1, .4]) scale(0.1) screw("M6x16");
        translate([0, insert_width-1-.3, panel_thickness-t_slot_cut_depth]) cube([4, 0.6, t_slot_cut_depth]);
        }
        }
    }
    
    for (i= [0 : 0])
    {
        if (wheel_config == 1)
        {
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -bracket_start-insert_width, 0]) 
        {
        cube([mounted_wheel_depth, insert_width, 1]);
        $fn=36;
        //translate([-1.4, 5-1, .4]) scale(0.1) screw("M6x16");
        }
        
        mirror([0, 1, 0])
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -12/2, 0]) 
        {
        cube([mounted_wheel_depth, 5, 1]);
        $fn=36;
        //translate([-1.4, 5-1, .4]) scale(0.1) screw("M6x16");
        }
        }
        
        mirror([1, 0, 0])
        {
                if (wheel_config == 1)
        {
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -12/2, 0]) 
        {
        cube([mounted_wheel_depth, 5, 1]);
        $fn=36;
        //translate([-1.4, 5-1, .4]) scale(0.1) screw("M6x16");
        }
        
        mirror([0, 1, 0])
        translate([-wmb_pio-(i*(2.8+mounted_wheel_depth)), -12/2, 0]) 
        {
        cube([mounted_wheel_depth, 5, 1]);
        $fn=36;
        //translate([-1.4, 5-1, .4]) scale(0.1) screw("M6x16");
        }
        }
        }
    } 
}

module WheelPanelPrefab(rotation, radius, cell_size, wall_thickness, thickness, border_edge, vent = true, render_color, show_mount = true, show_rest = false, wheel_config = 0, render_panel = true) {

    // Wheel config
    // 0. static stable only
    // 1. front cradle fixed or steerable standard
    // 2. right (facing me) cradle fixed standard
    // 3. left (facing me) cradle fixed standard

    difference() {
        // TODO: Evaluate what this size should be, where it should be
        // if there should be additional support mechanisms (esp if not metal)
        // prior to 2nd print run
        mounted_wheel_depth = 0.8 + 0.002;

        shift_forward_dist = (wheel_config == 2 ? 1 : -1) * 0.5;
        front_wheel_shift = 0.0; // -1.6; // -1.9

        // The forward rotation constraint vector depends on 'how high off the ground the front wheel is'
        // When flat, 0 standard wheels spin out away from each other
        // and 36 spin inward towards each other
        // Expected to be somewhere in the middle of the range from 0-36 degrees
        // (Between static stable mode and 'tetrahedron C uptilt forward')

        // approximated by iteration from visual inspection of orthographic front view mount self-occlusion
        standard_side_wheel_tilt = 24.635;

        stationary_rot = rotation;
        rotate_wheel_z = 0;

        translate([0, 0, 0]) {
            if (show_mount) {
                 {
                    // In triwheel mode, the front wheel faces directly forward

                        if (wheel_config == 1)
                        {
                            translate([(wheel_config == 1 ? -wmb_pio / 2 : -wmb_pio) + 2.3, 0, -front_panel_to_wheel_center + 0.5 + panel_thickness * 1.65])
                            rotate([-90, 0, -90]) MountedOmniBall(mounted_wheel_depth, front_panel_to_wheel_center);
                            // Use Omniball Brace
                        } else
                        {
                            if (robot_mode) {
                            rotate_wheel_z = wheel_config == 2 ? -standard_side_wheel_tilt : (wheel_config == 3 ? standard_side_wheel_tilt : (wheel_config == 1 ? -90 : 0));
                            translate([wheel_config == 1 ? front_wheel_shift - 0.5 : 0, 0, 0])
                            rotate([0, 0, rotate_wheel_z])
                            {
                            
                            translate([0, -shift_forward_dist, 0])
                            // The exact displacement of the front wheel mount to be even with the side wheels
                            // depends on the profile of the scooter wheels for exact calculation
                            translate([(wheel_config == 1 ? -wmb_pio / 2 : -wmb_pio), 0, -back_panel_to_wheel_center  + 0.5 + panel_thickness * 1.65])
                            rotate([-90, 0, -90])
                            union()
                            {
                            MountedWheel(mounted_wheel_depth, wheel_config);
                            }
                            rotate([0, 0, 180]) translate([wmb_pio-0.8, wheel_config == 3 ? -0.5: 0.5, panel_thickness]) MotorAttachment();
                            }
                        } else {
                            translate([(wheel_config == 1 ? -wmb_pio / 2 : -wmb_pio), 0, -back_panel_to_wheel_center  + 0.5 + panel_thickness * 1.65])
                            rotate([-90, 0, -90])
                            //MountedOmniBall();
                            MountedWheel(mounted_wheel_depth);
                        }
                    }
                }
            }
            difference() {
                // For back wheels, rotate Z standard_side_wheel_tilt
                // translate([10, 0, 0]) rotate([180, 0, 36])
                
                if (render_panel)
                {
                rotate([0, 0, stationary_rot])
                difference() {
                    ConnectorPentagonPlate(radius, cell_size, wall_thickness, thickness, border_edge, true, render_color, [3, 3, 6, 3, 3], [4, wheel_config == 2 ? 14 : 4, wheel_config == 1 ? 22 : 19, wheel_config == 3 ? 14 : 4, 4], [wheel_config == 1 ? 1 : 0, 0, 1, 0, wheel_config == 1 ? 1 : 0], [standard_secure_spacing, standard_secure_spacing, power_secure_spacing, standard_secure_spacing, standard_secure_spacing]);
                }
                if (wheel_config == 1)
                {
                    // Diff omniball mount slits
                    translate([(wheel_config == 1 ? -wmb_pio / 2 : -wmb_pio) + 2.3, 0, -front_panel_to_wheel_center + 0.5 + panel_thickness * 1.65]) rotate([-90, 0, -90]) MountedOmniBall(mounted_wheel_depth, front_panel_to_wheel_center);
                }
                else
                {
                rotate_wheel_z = wheel_config == 2 ? -standard_side_wheel_tilt : (wheel_config == 3 ? standard_side_wheel_tilt : (wheel_config == 1 ? -90 : 0));
                
                translate([wheel_config == 1 ? front_wheel_shift + 0.5 : 0, 0, 0])
                rotate([0, 0, rotate_wheel_z])
                translate([0, -shift_forward_dist, 0])
                
                union()
                {
                // Belt passthrough circle
                translate([-wmb_pio - 1.15, 0, 0])
                {
                    hull()
                    {
                    if (wheel_config == 2)
                    {
                    translate([0, 1.5, 0]) cylinder(4, 0.4, 0.4, $fn=64);
                    translate([0, -1, 0]) cylinder(4, 0.4, 0.4, $fn=64);
                    } else
                    {
                    translate([0, 1, 0]) cylinder(4, 0.4, 0.4, $fn=64);
                    translate([0, -1.5, 0]) cylinder(4, 0.4, 0.4, $fn=64);
                    }
                    }
                }
                rotate([0, 0, 180]) translate([wmb_pio-0.8, 0.0, panel_thickness]) GearmotorBracketScrewHoles();
                WheelMountSlots(wheel_config);
                }
                }
                
                }
            }

            if (show_rest) {
                difference() {
                    translate([-wmb_pio + 0.5, 0, 0])
                    CradleRest();

                    translate([-wmb_pio + 1, -2.0, -(-bracket_height / 2 - panel_thickness)])
                    scale(0.1)
                    rotate([0, 90, 0])
                    cylinder(20, 7, 7);

                    translate([-wmb_pio + 1, 2.0, -(-bracket_height / 2 - panel_thickness)])
                    scale(0.1)
                    rotate([0, 90, 0])
                    cylinder(20, 7, 7);
                }

                translate([-wmb_pio + 0.5 + 0.5, -2.0, -(-bracket_height / 2 - panel_thickness)])
                scale(0.1)
                rotate([0, 90, 0])
                screw("M6x25");

                translate([-wmb_pio + 0.5 + 2 - 2.5, -2.0, -(-bracket_height / 2 - panel_thickness)])
                scale(0.1)
                rotate([0, 90, 0])
                nut("M6");

                translate([-wmb_pio + 0.5 + 0.5, 2.0, -(-bracket_height / 2 - panel_thickness)])
                scale(0.1)
                rotate([0, 90, 0])
                screw("M6x25");

                translate([-wmb_pio + 0.5 + 2 - 2.5, 2.0, -(-bracket_height / 2 - panel_thickness)])
                scale(0.1)
                rotate([0, 90, 0])
                nut("M6");
            }
        }
    }
}
// depth of wheel mount

// sphere at start mount
//$fn=36;
//triangular_prism_offset = bracket_height/tan(tetra_a);
//o = sin(90-tetra_a) * 1;
//translate([-wmb_pio+0.5+triangular_prism_offset+1, 0, 0]) sphere(1);

//translate([-wmb_pio+0.5, 0, 0]) CradleRest();

module RestPrefabHoles(rotation, radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color)
{
    translate([-wmb_pio+1, -2.0, -(-
    bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) cylinder(35, 7, 7);
    
    translate([-wmb_pio+1, 2.0, -(-
    bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) cylinder(35, 7, 7);
}

module RestPrefab(rotation, radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color, show_screws=false)
{
    difference()
    {
    translate([-wmb_pio+0.5, 0, 0]) CradleRest();
    
    translate([-wmb_pio+1, -2.0, -(-
    bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) cylinder(20, 7, 7);
    
    translate([-wmb_pio+1, 2.0, -(-
    bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) cylinder(20, 7, 7);
    }
    
    if (show_screws)
    {
    translate([-wmb_pio+0.5+0.5, -2.0, -(-
    bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) screw("M6x25");
    
    translate([-wmb_pio+0.5+2-2.5, -2.0, -(-bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) nut("M6");
    
    translate([-wmb_pio+0.5+0.5, 2.0, -(-bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) screw("M6x25");
    
    translate([-wmb_pio+0.5+2-2.5, 2.0, -(-bracket_height/2-panel_thickness)]) scale(0.1) rotate([0, 90, 0]) nut("M6");
    }
}



rotate([0, -tetra_a, 0])
{

}

WheelPanelPrefab(36, panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true, color([0, 1, 1, 1]), false, show_rest=false, 1);
