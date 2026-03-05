include <crinoline.scad>

$fn = 64;

/* [Main Configuration] */
Number_Of_Segments = 3;
Max_Outer_Radius   = 12; 
Segment_Height     = dodecahedron_radius; 
Wall               = 0.8;
Overlap_Width      = 0.5; 
Clearance          = 0.4; 
Lip_H              = 2; 

/* [View Settings] */
Mode = "Assembled"; // [Assembled, Print]
Extension = 1.0; 
Debug_Slice = false; 

/* [Geometry Engine] */

module TrueRoundedTri(r, corner_r, h) {
    linear_extrude(h) {
        offset(r = corner_r) {
            actual_r = r - corner_r;
            polygon([
                [actual_r * cos(90),  actual_r * sin(90)],
                [actual_r * cos(210), actual_r * sin(210)],
                [actual_r * cos(330), actual_r * sin(330)]
            ]);
        }
    }
}

module TelescopingSegment(r, wall, total_h, is_tip, is_base, overlap) {
    cr = 3; 
    inner_r = r - wall;
    // The narrowest point of the catchment hole
    catch_r = inner_r - overlap - (Clearance/2);

    difference() {
        // --- THE SOLID BODY ---
        union() {
            // 1. BASE FLARE (Tapers inward from r+overlap to r)
            if (!is_base) {
                hull() {
                    TrueRoundedTri(r + overlap, cr, 0.01); 
                    translate([0,0,Lip_H]) TrueRoundedTri(r, cr, 0.01);
                }
            }

            // 2. MAIN SHELL & CATCHMENT HOUSING
            shell_z = is_base ? 0 : Lip_H;
            shell_h = total_h - shell_z;
            translate([0,0,shell_z]) TrueRoundedTri(r, cr, shell_h);
        }

        // --- THE HOLLOW CORE (Subtracting from the solid body) ---
        translate([0, 0, -1]) {
            if (is_tip) {
                // If it's the tip, just drill straight through
                TrueRoundedTri(inner_r, cr, total_h + 2);
            } else {
                // Drill the main hole up to the start of the catchment
                TrueRoundedTri(inner_r, cr, total_h - Lip_H + 1);
                
                // Create the tapered "ceiling" (Catchment)
                // We do this by hulling the main inner hole to the narrower catch hole
                translate([0, 0, total_h - Lip_H + 1])
                hull() {
                    TrueRoundedTri(inner_r, cr, 0.01);
                    translate([0, 0, Lip_H + 1]) TrueRoundedTri(catch_r, cr, 0.01);
                }
            }
        }
    }
}

/* [Assembly Logic] */

module Assembly() {
    grid_size = (Max_Outer_Radius + Overlap_Width) * 2 + 10;
    for (i = [0 : Number_Of_Segments - 1]) {
        this_r = Max_Outer_Radius - (i * (Wall + Overlap_Width + Clearance));
        
        x_pos = (Mode == "Print") ? (i * grid_size) : 0;
        
        // Travel: The top of Segment i flare (Z=Lip_H) meets 
        // the bottom of Segment i-1 catchment (Z=Total_H - Lip_H).
        // Travel distance = Total_H - Lip_H.
        travel = Segment_Height - Lip_H;
        z_pos = (Mode == "Assembled") ? (i * travel * Extension) : 0;

        if (this_r > Wall + Overlap_Width) {
            translate([x_pos, 0, z_pos])
            color([0.2, 0.4 + (i/Number_Of_Segments)*0.5, 0.8, 1.0])
            TelescopingSegment(this_r, Wall, Segment_Height, (i == Number_Of_Segments-1), (i == 0), Overlap_Width);
        }
    }
}

module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size) {
      dihedral = 116.565;
      intersection(){
            box(size);
            intersection_for(i=[1:5])  { 
                rotate([dihedral, 0, 360 / 5 * i])  box(size); 
           }
      }
}

rotate([0, 0, 15])
{
if (Debug_Slice) {
    difference() {
        Assembly();
        rotate([0,0,30]) translate([-100, 0, -10]) cube([200, 200, Segment_Height * Number_Of_Segments + 50]);
    }
} else {
    rotate([0, 0, 180])
    Assembly();
}


rotate([-20.9052*1.5, 0, 0])
dodecahedron(dodecahedron_radius*1.56);

for (i = [0:2]) {
    rotate([0, 0, 120*i])
    translate([0, -15, -20]) sphere(6);
}
    
//color([0.0, 1.0, 1.0, 0.2])
//sphere(dodecahedron_radius);

translate([0, 0, 65])
cylinder(2, dodecahedron_radius/2, dodecahedron_radius/2);

color([1.0, 0.0, 1.0, 0.9])
translate([0, 0, -dodecahedron_radius/1.5])
Crinoline();
}