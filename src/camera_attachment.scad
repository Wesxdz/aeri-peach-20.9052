//color([1.0, 0.0, 0.0, 0.4]) import("elp/ELP_Mount_Top.stl");

include <dodecahedroid_config.scad>
include <nutsnbolts/cyl_head_bolt.scad>

$fn=64;

// Our lovely ELP Fish Eye
module Camera(radius = 0.8)
{
$fn=128;
    //color([0, 0.3, 0, 1]) 
    cube([3.8, 3.8, 0.1], center=true); // board
    //color([0, 0, 0, 1]) 
    cylinder(0.8*2.54, radius, radius); // camera
    cable_plug_width = 0.6;
    cable_plug_height = 0.4;
    cable_plug_depth = 0.3;
    translate([3.8/2-cable_plug_height/2, 1.0, (-0.1-cable_plug_depth)/2]) cube([cable_plug_height, cable_plug_width, cable_plug_depth], center=true);
}
m2_clear = 0.02;
m2_screw_clearance = 0.1 + m2_clear;

module place_camera_attachment_screw_holes(size, thickness) {
    angle = 360 / 5;
    base_coords = [
      [size * cos(0), size * sin(0)],
      [0.65* size * cos(angle), 0.65* size * sin(angle)],
      [0.65* size * cos(2 * angle), 0.65* size * sin(2 * angle)],
      [size * cos(3 * angle), size * sin(3 * angle)],
      //[size * cos(4 * angle), size * sin(4 * angle)]
    ];
    for (i = [0:len(base_coords)-1])
    {
        
        translate(base_coords[i]) rotate([0, 180, 0]) cylinder(10, (0.3+screw_clearance)/2, (0.3+screw_clearance)/2);
    }
}

module ELP_BoardRest()
{
    board_size = 3.8;
    board_height = 0.15;
    lens_mount_height = 0.37;
    board_clearance = 0.1;
    mount_points = [[1, 1, 0], [-1, 1, 0], [-1, -1, 0], [1, -1, 0]];
    difference()
    {
    hull()
    {
    for (i = [0:len(mount_points)-1])
    {
        translate(mount_points[i]*board_size/2) cylinder(lens_mount_height+board_height , 0.2, 0.2);
    }
    }
    translate([0, 0, board_height/2+lens_mount_height]) cube([board_size+board_clearance, board_size+board_clearance, board_height], center=true);
    }
}

module ELP_TopMount()
{
board_size = 3.8;
lens_mount_height = 0.37;
inner_mount_spacing = 2.8;
ims_d = inner_mount_spacing/2;

above_board_height =  1.14 + 1.19;
target_panel_overhang = 0;

// The Module Mechanical Dimensions for the camera height are inaccurate...
//spacing_height = above_board_height - panel_thickness;

difference()
{
    // base square
    // color([0.0, 1.0, 0.0, 0.4]) 
    union()
    {
    translate([0, 0, -lens_mount_height/2]) ELP_BoardRest();
    cube([board_size, board_size, lens_mount_height], center=true);
    }
    
    union()
    {
    
    mount_points = [[1, 1, 0], [-1, 1, 0], [-1, -1, 0], [1, -1, 0]];
    for (i = [0:len(mount_points)-1])
    {
        translate([0, 0, -1]) translate(mount_points[i]*ims_d) cylinder(2, m2_screw_clearance, m2_screw_clearance);
    }
    
    cylinder(4, 0.7, 0.7);
    cylinder(4, 0.7, 0.7);
    
    //cube([2.0, 2.0, 2.0], center=true);
    hull()
    {
    for (i = [0:len(mount_points)-1])
    {
        translate([0, 0, -1]) translate(mount_points[i]*1.0) cylinder(2, 0.05, 0.05);
    }
    }
    
    // no idea what to call this...
    // lens_to_board = 0.25;
    cube([2.3, 0.5, 2.0], center=true);
    translate([-1.15, 0, 0]) cylinder(4, 0.25, 0.25, center=true);
    translate([1.15, 0, 0]) cylinder(4, 0.25, 0.25, center=true);
    
    // 5V plug upper pins
    translate([0.5+0.025, 1.2, 0]) cube([1.0+0.05, 0.7, 1.0], center=true);
    
    }
}
}

module ELP_BottomMount()
{
lens_mount_height = 0.37;
inner_mount_spacing = 2.8;
ims_d = inner_mount_spacing/2;
size = 8-pcorner_dist;
angle = 360 / 5;
base_coords = [
  [size * cos(0), size * sin(0)],
  [0.65* size * cos(angle), 0.65* size * sin(angle)],
  [0.65* size * cos(2 * angle), 0.65* size * sin(2 * angle)],
  [size * cos(3 * angle), size * sin(3 * angle)],
  //[size * cos(4 * angle), size * sin(4 * angle)]
];

difference()
{

    union()
    {
    rotate([0, 0, -18]) translate([0, 0, -lens_mount_height/2])
    {
    difference()
    {
    hull()
    {
    for (i = [0:len(base_coords)-1])
    {
        translate(base_coords[i]) rotate([0, 180, 0]) cylinder(0.28, 0.8, 0.8);
    }
    }
    place_camera_attachment_screw_holes(8-pcorner_dist, panel_thickness);
    }
    }
    }
    
    mount_points = [[1, 1, 0], [-1, 1, 0], [-1, -1, 0], [1, -1, 0]];
    for (i = [0:len(mount_points)-1])
    {
        translate([0, 0, -1]) translate(mount_points[i]*ims_d) cylinder(10, m2_screw_clearance, m2_screw_clearance);
        translate([0, 0, -2.4]) translate(mount_points[i]*ims_d) cylinder(2, 0.3, 0.3);
    }
}

    mount_points = [[1, 1, 0], [-1, 1, 0], [-1, -1, 0], [1, -1, 0]];
    for (i = [0:len(mount_points)-1])
    {   
        // Show screws
        //translate([0, 0, -0.4]) translate(mount_points[i]*ims_d) rotate([0, 180, 0]) scale(0.1) screw("M2x8");
        // cylinder(0.8, 0.1, 0.1);
    }
}

scale(1)
{
union()
{
ELP_TopMount();
difference()
{
ELP_BottomMount();
rotate([0, 180, 0]) translate([0, 0, -0.1]) Camera(0.95);
}
}
}