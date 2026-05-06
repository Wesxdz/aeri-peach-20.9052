// TS35 DIN Rail - 12 inches (30.48 cm)
// 25mm slots, cropped end, and beveled INNER joints (the "elbows")

include <dodecahedroid_config.scad>

/* [Dimensions] */
length_in_cm = 30.48; 
length = length_in_cm * 10; 
thickness = 1;
inner_bevel = 1;       // Bevel at the wall-to-flange connection

/* [Slot Parameters] */
slot_length = 25;       
slot_width = 5.2;       
slot_pitch = 36;        
first_slot_offset = 18; 

/* [Hidden Profile Constants] */
w = 35;                 // Total Width
d = 7.5;                // Total Depth
f = 5;                  // Flange width
inner_w = w/2 - f;      // X-coord of the vertical walls

module ts35_profile() {
    union() {
        children_profile();
        mirror([1, 0, 0]) children_profile();
    }
}

module children_profile() {
    polygon(points=[
        [0, 0],                                              // Center bottom
        [inner_w, 0],                                        // Bottom inner corner
        [inner_w + thickness, 0],                            // Bottom outer corner
        [inner_w + thickness, d - thickness - inner_bevel],  // Up outer wall, stop for bevel
        [inner_w + thickness + inner_bevel, d - thickness],  // 45° bevel out to underside
        [w/2, d - thickness],                                // Across underside to edge
        [w/2, d],                                            // Up square edge
        [inner_w, d],                                        // Across top face
        [inner_w, thickness],                                // Down inner wall
        [0, thickness]                                       // Back to center
    ]);
}

module DIN_RailBoundingBox() {
    translate([-w/2, 0, 0]) {
        cube([w, d, length]);
    }
}

module DIN_RailLowerSlits() {
//    translate([-w/2, 0, 0]) {
//        cube([w, d, length]);
//    }
    for (i = [0:17])
    {
    translate([0, 0, (i+0.5)*length/18])
    rotate([90, 0, 0])
    scale(10)
    BrassInsert();
    }
}

module capsule_slot() {
    hull() {
        translate([0, 0, -slot_length/2 + slot_width/2])
            rotate([90, 0, 0])
            cylinder(d=slot_width, h=thickness * 10, center=true, $fn=24);
        translate([0, 0, slot_length/2 - slot_width/2])
            rotate([90, 0, 0])
            cylinder(d=slot_width, h=thickness * 10, center=true, $fn=24);
    }
}

module TS35_DIN_Rail()
{   
    color([0.8, 0.8, 0.8, 1.0])
    difference() {
        linear_extrude(height = length) {
            ts35_profile();
        }
        
        for (z = [first_slot_offset : slot_pitch : length + slot_length]) {
            translate([0, thickness/2, z])
                capsule_slot();
        }
    }
}

//TS35_DIN_Rail();
//DIN_RailBoundingBox();
//DIN_RailLowerSlits();