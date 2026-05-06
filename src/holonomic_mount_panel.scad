use <connector_pentagon_plate.scad>
include <lift_mount_vertex_connector.scad>
include <dodecahedroid_config.scad>

$fn = 72;

module HolonomicMountPanel(panel = true, lug = true) {
    mount_x = -panel_radius + pcorner_dist;
    y_offsets = [-1.5, 1.5];

    difference() {
        // 1. ADDITIVE
        union() {
            if (panel) NeoCradlePanel();

            if (lug) {
                translate([mount_x, 0, panel_thickness]) difference() {
                    translate([0, -2, 0]) cube([2.5, 4, 4]);
                    
                    for (y = y_offsets) 
                        translate([1, y, 0]) BrassInsert();
                }
            }
        }

        // 2. SUBTRACTIVE
        union() {
            // Filament savers
            if (panel) {
                for (m = [0, 1]) mirror([0, m, 0]) 
                hull() {
                    translate([1, 6, 0])  cylinder(panel_height, 2.8, 2.8);
                    translate([-4, 5, 0]) cylinder(panel_height, 2.5, 2.5);
                }
            }

            // Global M3 through-holes (cut everything)
            if (panel || lug) {
                for (y = y_offsets) 
                    translate([mount_x + 1, y, 0]) 
                        cylinder(30, m3_rad, m3_rad, center=true);
            }
        }
    }
}

// --- Usage Examples ---

// Default (Both)
//HolonomicMountPanel();

// Panel Only
//HolonomicMountPanel(lug=false);

// Lug Only
//HolonomicMountPanel(panel=false);

module CradleHolonomicCutoutPanel()
{
//translate([0, 0, dodecahedron_radius-vertex_tehtra_height_truncation]) // approximately...
rotate([-tetra_a, 0, 0])
difference()
{

rotate([-magic_angle, 0, 0])
for (i = [0 : len(pos)-1]) {
    
    if (i == 9)
//    if (face_groups[i] == 3)
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    HolonomicMountPanel(lug=false);
    }
}

union()
{
pulley_cutout_radial_offset = 5.8;

rotate([0, 0, 60])
union()
{
for (i = [0 : len(pos)-1]) 
{
    if (face_groups[i] == 3)
    {
    rotate([180, 0, -30+i*120])
    translate([pulley_cutout_radial_offset, 0, 0])
    hull()
    {
        translate([0, 2, 10]) cylinder(20, 1, 1);
        translate([0, -2, 10]) cylinder(20, 1, 1);
    }
    }
}
}

}

}
}


//translate([0, 0, -21.5]) scale(0.1) rotate([0, 0, -30]) 
//{
//IntegratedLift();
//scale(10) BaseMountAttachment();
//rotate([0, 180, 0])
//CentralOmniballMountSupport();
//}
scale(10) CradleHolonomicCutoutPanel();

