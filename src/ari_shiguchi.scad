// --- Helper Profile (2D) ---
module trapezoid_profile(nw, jd, ang) {
    ww = nw + 2 * (jd * tan(ang));
    polygon(points = [
        [-nw/2, 0],   // Front Left
        [nw/2, 0],    // Front Right
        [ww/2, jd],   // Back Right
        [-ww/2, jd]   // Back Left
    ]);
}

// Male Part (Tenon)
module Oguchi(h=40, nw=25, jd=30, ang=15, bw=80, bd=40, is_cutout=false, m_top=0, m_bottom=0) {
    wood_color = [0.63, 0.32, 0.18];
    ghost_color = [0.63, 0.32, 0.18, 0.5]; 

    color(is_cutout ? ghost_color : wood_color) {
        // The Beam (rendered only for the actual part)
        if (!is_cutout) {
            translate([-bw/2, -bd, 0]) cube([bw, bd, h]);
        }

        // The Tenon Logic (Now applies margins to BOTH part and cutout)
        hull() {
            // Bottom 
            translate([0, 0, is_cutout ? -0.1 : 0])
                linear_extrude(height = 0.1)
                    trapezoid_profile(nw + (m_bottom * 2), jd + m_bottom, ang);

            // Top
            translate([0, 0, h - 0.1])
                linear_extrude(height = 0.1)
                    trapezoid_profile(nw + (m_top * 2), jd + m_top, ang);
        }
    }
}

// Female Part (Mortise)
module Meguchi(h=40, nw=25, jd=30, ang=15, bw=80, m_top=0.2, m_bottom=0) {
    difference() {
        translate([-bw/2, 0, 0]) cube([bw, jd + 20, h]);
        // The cutout inside Meguchi uses the same margin logic
        Oguchi(h=h, nw=nw, jd=jd, ang=ang, bw=bw, is_cutout=true, m_top=m_top, m_bottom=m_bottom);
    }
}

// --- TEST SECTION ---

// 1. Check the Male Part (Oguchi)
// Setting m_top to 10 makes the MALE part a massive wedge
//translate([-60, 0, 0])
//    Oguchi(m_top=-2, m_bottom=0); 

// 2. Check the Female Part (Meguchi)
// Setting m_top to 10 makes the HOLE a massive wedge
//translate([60, 0, 0])
//    Meguchi(m_top=0, m_bottom=0);