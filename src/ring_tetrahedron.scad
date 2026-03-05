$fn = 60;

// --- ADJUSTED FOR NARROWER FOOTPRINT (METERS) ---
robot_height = 1.7;    
hip_height = 0.95;     
robot_width = 0.45;    

ring_radius = 0.35;    
base_radius = 0.75;    // Reduced from 1.2 (Total width is now 1.5m)

sphere_r = 0.12;       
rod_r = 0.04;          

// --- Calculations ---
run = base_radius - ring_radius;
tilt_angle = atan2(hip_height, run); // The rods are now steeper (~67 degrees)

// 1. THE HUMANOID
color([0.2, 0.5, 1.0, 0.3]) { 
    translate([0, 0, hip_height]) 
        cylinder(h=robot_height-hip_height, r=robot_width/2);
    translate([0, 0, 0]) 
        cylinder(h=hip_height, r=robot_width/1.8);
}

// 2. THE HIP RING
color("Silver")
translate([0, 0, hip_height]) {
    rotate_extrude() 
        translate([ring_radius, 0, 0]) 
            circle(r=0.03); 
}

// 3. THE LEGS & OMNIBALLS
for (a = [0, 120, 240]) {
    rotate([0, 0, a]) {
        // The Pod (Weighted for stability)
        translate([base_radius, 0, 0]) {
            rotate([0, 90 - tilt_angle, 0]) { 
                color("DarkSlateGray") sphere(sphere_r);
            }
            // Visualizing a weighted motor housing
            //%cylinder(h=0.2, r=0.15, center=true); 
        }
        // The Structural Rod (Steeper Angle)
        color("Gray")
        hull() {
            translate([base_radius, 0, 0]) sphere(rod_r); 
            translate([ring_radius, 0, hip_height]) sphere(rod_r); 
        }
    }
}