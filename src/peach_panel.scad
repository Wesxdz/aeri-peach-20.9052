include <dodecahedroid_config.scad>
include <connector_pentagon_plate.scad>
include <peach_core.scad>

//PeachPanel();

// TODO: Mechanism to map physical size of peach core to
// design size based on reference of 
// 1. Max height of png mask (automatic) 474 pixels
// 2. Physical size 20 mm

image_height = 512;
max_mask_height = 474;
peach_core_height = 2.9;
default_scale = 1.1 * 1/image_height * peach_core_height*image_height/max_mask_height; // svg is one cm at 1/512 scale
// 1/474 * pixel_to_cm;


module CorePanelMask(expand=1/image_height)
{
intersection()
{
ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false);
rotate([0, 0, 180+18+72*2]) translate([0, 0, -panel_thickness])linear_extrude(10) scale(default_scale+expand) import("core_outline.svg", $fn = 10, center=true);
//default_scale+
}
}

module CoreVolume()
{
$fn=128;
hull()
{
scale(0.5) translate([0, 0, 0.8]) CorePanelMask(0);
CorePanelMask(0);
scale(0.5) translate([0, 0, -0.8]) CorePanelMask(0);
}
}

//CoreVolume();

//translate([0, -1, 0])
//rotate([-90, -18, 0])

module FleshBleed()
{
    mx_switch_depth = 0.362;
    brass_insert_height = 0.4;
    
    anchor_offset = 1.8;
    panel_attachment_offset = 2.5;
    
    union()
    {
    linear_extrude(panel_thickness+brass_insert_height) projection()
    difference()
    {
        CorePanelMask((1/image_height)*0.9);
        CorePanelMask((1/image_height)*0.3); // 3 mm core padding...
    }
    

        translate([0, 0, panel_thickness])
        {
        difference()
        {
            hull()
            {
                linear_extrude(brass_insert_height) projection()
                CorePanelMask((1/image_height) * 1.3);
                linear_extrude(0.1) projection()
                CorePanelMask((1/image_height) * 1.5);
                rotate([0, 0, -18])
                {
                translate([panel_attachment_offset, 0, 0]) cylinder(mx_switch_depth, 0.5, 0.5);
                translate([-panel_attachment_offset, 0, 0]) cylinder(mx_switch_depth, 0.5, 0.5);
                }
            }
            union()
            {
            linear_extrude(brass_insert_height) projection()
            CorePanelMask((1/image_height)*0.3);
            rotate([0, 0, -18])
            {
            translate([anchor_offset, 0, 0]) BrassInsert();
            translate([-anchor_offset, 0, 0]) BrassInsert();
            
            translate([panel_attachment_offset, 0, 0]) BrassInsert();
            translate([-panel_attachment_offset, 0, 0]) BrassInsert();
            }
            }
        }
        }
     }
}

//FleshBleed();
//rotate([0, 180, -18]) translate([0, 0, -0.83])
//KeycapAttachment();
//CoreVolume();
//scale(10) PeachCorePanel();

module PeachCorePanel(vent=true)
{
config_rot = 18+72*2;
union()
{
//rotate([0, 0, config_rot]) PeachPanelMountScrews();
difference()
{
union()
{
    union()
    {
    ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vent);
    //linear_extrude(panel_thickness) rotate([0, 0, -18-180]) translate([-0.35, 8, 0]) scale(0.05) mirror([0, 0, 0]) Leaf();
    intersection()
    {
    union()
    {
    rotate([-90, 0, config_rot]) PeachPanelMountNoVent();
    rotate([0, 0, config_rot]) translate([0, -0.5, 0])linear_extrude(10) scale(6.7*(default_scale+(1/image_height))) import("peach_vent.svg", $fn = 10, center=true);
    }
    ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false);
    }
    }

// non-vent zone around peach core
CorePanelMask((1/image_height)*1.5);
}

union()
{
rotate([0, 0, 180+config_rot]) translate([0, 0, -panel_thickness])linear_extrude(10) scale(default_scale+(1/image_height)) import("core_outline.svg", $fn = 10, center=true);
rotate([-90, 0, config_rot]) PeachPanelMountHoles();

// Port cutout for Jetson plugin
port_width = 20;
port_height = 0.5;

union()
{
hull()
{
    rotate([0, 0, 180+config_rot]) translate([0, 6, 0]) 
    {
        translate([-port_width/2, 0, 0]) cylinder(1, port_height, port_height);
        translate([-port_width/2+2, 1.6, 0]) cylinder(1, port_height, port_height);
        translate([port_width/2, 0, 0]) cylinder(1, port_height, port_height);
        translate([port_width/2-2, 1.6, 0]) cylinder(1, port_height, port_height);
    }
}

}

}
}

}

}

//
//scale(10) color([1, 0, 0]) FleshBleed();
rotate([0, 0, 18]) PeachCorePanel(true);
translate([4, 8, 0]) rotate([90, 90, 0]) Battery();
//color([0.9, 0.6, 0.6, 0.8]) CoreVolume();

module Battery()
{
    cube([13.2, 4.3, 2.5]);
};