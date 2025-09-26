include <pentagon_plate.scad>
include <dodecahedroid_config.scad>
include <connector_pentagon_plate.scad>
include <dodecahedroid_config.scad>
include <nutsnbolts/cyl_head_bolt.scad>

$fn=64;

module squashed_pentagon(size) {
angle = 360 / 5;
points = [
  [size * cos(0), size * sin(0)],
  [0.65* size * cos(angle), 0.65* size * sin(angle)],
  [0.65* size * cos(2 * angle), 0.65* size * sin(2 * angle)],
  [size * cos(3 * angle), size * sin(3 * angle)],
  [size * cos(4 * angle), size * sin(4 * angle)]
];
polygon(points);
}

// ELP Fish Eye
module Camera(radius = 0.8)
{
    //color([0, 0.3, 0, 1]) 
    cube([3.8, 3.8, 0.1], center=true); // board
    //color([0, 0, 0, 1]) 
    cylinder(0.8*2.54, radius, radius); // camera
    cable_plug_width = 0.6;
    cable_plug_height = 0.4;
    cable_plug_depth = 0.3;
    translate([3.8/2-cable_plug_height/2, 1.0, (-0.1-cable_plug_depth)/2]) cube([cable_plug_height, cable_plug_width, cable_plug_depth], center=true);
}

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

module place_camera_attachment_screws(size, thickness) {
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
        
        translate(base_coords[i]) rotate([0, 180, 0]) scale(0.1) screw("M3x12");
    }
}

module CameraPentagonPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, vent)
{
    shift_up = 7.5;
    union()
    {
        difference()
        {
        union()
        {
        ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true);
        intersection()
        {
        rotate([0, 0, 36]) translate([-shift_up,
        0, 0])  rotate([0, 0, -36*3]) linear_extrude(panel_thickness) squashed_pentagon(8);
        ConnectorPentagonPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false);
}
        }
        rotate([0, 0, 36]) translate([-shift_up, 0, -0.1]) Camera(0.95);
        }
    }
}

module CameraPlateScrews()
{
color([0.5, 0.5, 0.5, 0.5]) rotate([0, 0, 36]) translate([-7.5, 0, 0]) rotate([0, 0, -18-90])
place_camera_attachment_screws(8-pcorner_dist, panel_thickness);
}

module CameraAttachment(size, thickness)
{
    color([0.5, 0.5, 0.5, 0.5]) rotate([180, 0, 36]) translate([-7.5, 0, -panel_thickness]) rotate([0, 0, -18-90])
    {
    angle = 360 / 5;
    base_coords = [
      [size * cos(0), size * sin(0)],
      [0.65* size * cos(angle), 0.65* size * sin(angle)],
      [0.65* size * cos(2 * angle), 0.65* size * sin(2 * angle)],
      [size * cos(3 * angle), size * sin(3 * angle)],
      //[size * cos(4 * angle), size * sin(4 * angle)]
    ];
    hull()
    {
    for (i = [0:len(base_coords)-1])
    {
        
        translate(base_coords[i]) rotate([0, 180, 0]) cylinder(0.28, 0.8, 0.8);
    }
    }
    }
}

module CameraPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge)
{

difference()
{
CameraPentagonPanel(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true);
// The spacing on camera attachment should be the same as the vertex connector
// from the edge for uniform M3 exterior aesthetic
rotate([180, 0, 36]) translate([-7.5, 0, 1]) rotate([0, 0, -18-90])
place_camera_attachment_screw_holes(8-pcorner_dist, panel_thickness);
}

//color([0, 1, 1, 0.5]) rotate([180, 0, 36]) translate([-7.5, 0, -panel_thickness-0.9]) Camera(0.7);

//rotate([90, 0, 90+36]) translate([2.8, 0, 0]) scale(0.1) import("elp/ELP_Mount_Top.stl");

union()
{
difference()
{
CameraAttachment(8-pcorner_dist, panel_thickness);
rotate([0, 0, 36]) translate([-7.5, 0, panel_thickness/2+0.10]) rotate([0, 0, 90]) cube([4.0, 4.0, 10.0], center=true);
}
color([1, 0, 1, 0.5]) rotate([0, 0, 36]) translate([-7.5, 0, panel_thickness/2+0.10]) rotate([0, 0, 90])
intersection()
{
import("elp/ELP_Mount_Top.stl");
cube([4.2, 4.2, 10.0], center=true);
}
}
}

// CameraPlate(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, true);
//CameraPlateScrews();