// Samsung Galaxy S24 FE - Simple Model
// Dimensions based on actual phone specifications

module Phone()
{

    // Phone dimensions (in mm)
    phone_length = 162;
    phone_width = 77.3;
    phone_thickness = 8;
    corner_radius = 10;

    // Screen bezel
    bezel_width = 2;

    module rounded_rect(x, y, z, r) {
        hull() {
            translate([r, r, 0])
                cylinder(h=z, r=r, $fn=50);
            translate([x-r, r, 0])
                cylinder(h=z, r=r, $fn=50);
            translate([r, y-r, 0])
                cylinder(h=z, r=r, $fn=50);
            translate([x-r, y-r, 0])
                cylinder(h=z, r=r, $fn=50);
        }
    }

    // Main phone body
    color("MidnightBlue")
    rounded_rect(phone_width, phone_length, phone_thickness, corner_radius);

    // Screen (slightly inset)
    color("Black")
    translate([bezel_width, bezel_width, phone_thickness - 0.1])
        rounded_rect(phone_width - bezel_width*2, phone_length - bezel_width*2, 0.2, corner_radius - bezel_width);
    
}