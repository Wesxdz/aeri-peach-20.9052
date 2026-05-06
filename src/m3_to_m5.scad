// --- Parameters ---
$fn = 64; 

m3_inner_d   = 3.4;   // Clearance (prevents the "threaded hole" effect)
m5_slot_d    = 5.0;   // True M5 size (FDM will usually print this at ~4.9mm)
total_thick  = 2.5;   

// Screw Head Cutout 
// (Using the screw head itself as the washer)
head_d       = 5.6;   // M3 Socket heads are ~5.5mm
head_depth   = 0.8;   // Typical depth of one "step" or washer thickness

// --- The M5 Sized Puck ---
difference() {
    // 1. The Main Cylinder
    cylinder(h = total_thick, d = m5_slot_d);
    
    // 2. The Cutout 
    // This creates a seat so the head doesn't slide around
    translate([0, 0, total_thick - head_depth])
        cylinder(h = head_depth + 0.1, d = head_d);

    // 3. The M3 Through-Hole
    translate([0, 0, -1])
        cylinder(h = total_thick + 2, d = m3_inner_d);
}