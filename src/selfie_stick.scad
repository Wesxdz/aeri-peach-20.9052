include <GoProScad/GoPro.scad>
include <phone.scad>
include <vertex_connector.scad>

// https://www.amazon.com/dp/B0D6VWSQGC?ref=ppx_yo2ov_dt_b_fed_asin_title
module SelfieStick(radius, initial_height, section_height, sections)
{
    $fn = 36;
    cylinder(initial_height, radius, radius);
    for (i = [0 : sections-1])
    {
        section_rad = radius-(i/sections* radius/2);
        translate([0, 0, initial_height+i*section_height]) cylinder(section_height, section_rad, section_rad);
    }
    // nob for mounting
    translate([0, 0, initial_height+section_height*sections]) 
    {
    cylinder(14, radius*0.75, radius*0.75);
    translate([0, 0, 14]) 
    {
        translate([-38 , 3, 30]) rotate([90, 0, 0]) Phone();
        cylinder(2, radius+2, radius+2);
        translate([0, -1.5, 0]) gopro_mount_f(
            base_height = 3, 
            base_width = 24, 
            leg_height = 17, 
            nut_diameter = 11.5, 
            nut_sides = 4, 
            nut_depth = 3, 
            center = true);
         }
     }
}

difference()
{
    translate([0, 0, 3]) rotate([0, 180, 0]) VertexNotch([1, 1, 1]);
    scale(0.1) SelfieStick(27/2, 210, 180, 6);
}