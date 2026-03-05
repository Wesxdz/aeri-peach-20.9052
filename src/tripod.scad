$fn = 36;

// --- Animation Parameters ---
//r = 2 + 6 * (0.5 - 0.5 * cos($t * 360)); 
r = 6;

// --- Constant Rod Length Logic ---
rod_length = 10; 
h = sqrt(pow(rod_length, 2) - pow(r, 2));

// --- Rotation Calculation ---
// Calculate the angle the spheres need to tilt to face the apex
// 90 - atan(h/r) gives the tilt from the vertical
tilt_angle = 90 - atan2(h, r);

sphere_r = 1;   
rod_r = 0.2;    

// 1. The Top Sphere (The Apex)
translate([0, 0, h]) 
    sphere(sphere_r);

// 2. The Base Spheres and Rods
for (a = [0, 120, 240]) {
    rotate([0, 0, a]) {
        
        // Place and Rotate the base sphere
        translate([r, 0, 0]) 
            rotate([0, -tilt_angle, 0]) // Tilt inward toward center
            //scale(0.02) import("omniball.stl");
            sphere(sphere_r);
        
        // Create the rod using hull
        hull() {
            translate([r, 0, 0]) sphere(rod_r); 
            translate([0, 0, h]) sphere(rod_r); 
        }
    }
}

//scale(0.02) import("omniball.stl");