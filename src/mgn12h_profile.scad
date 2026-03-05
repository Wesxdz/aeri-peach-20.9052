// MGN12 Rail Profile with Gothic Arch Cutout
linear_extrude(20) {
    difference() {
        // Main Rail Body (12mm wide, 8mm tall)
        // Centered for easier math
        square([12, 8], center = true);
        
        // Left Side Cutout
        translate([-6, 0])  // Move to left edge (4mm from bottom if centered)
            union() {
                rotate([0, 0, 45]) square([2, 2], center = true); // The V-groove
                circle(r = 0.8, $fn = 20); // The radius at the base of the groove
            }
            
        // Right Side Cutout
        translate([6, 0]) 
            union() {
                rotate([0, 0, 45]) square([2, 2], center = true);
                circle(r = 0.8, $fn = 20);
            }
            
        // Bottom Mounting Relief (Standard on most MGN12 rails)
        translate([0, -4]) 
            square([7.5, 1.5], center = true);
    }
}