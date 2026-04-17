include <dodecahedroid_config.scad>

$fn=36*2;

module TouchButton()
{
scale(10)
difference()
{
hull()
{
cylinder(0.3, 0.4, 0.4);


translate([1.0, 0, 0])
cylinder(0.4, 0.8, 0.8);
}

// m3 screw sink
union()
{
translate([0, 0, 0.2])
cylinder(0.5, 0.26, 0.26);
cylinder(0.5, m3_rad, m3_rad);
}
}
}

//TouchButton();

module ArchimedeanSpiral()
{
PI = 3.14159;

dots = 32;            // number of dots
dot_dist = 5;          // distance between points
arm_len = 5;           // ray length
init_radian = PI * 2;  // initial angle

b = arm_len / 2 / PI;

function r(b, theta) = b * theta;

function radian_step(b, theta, l) = 
    acos((2 * pow(r(b, theta), 2) - pow(l, 2)) / (2 * pow(r(b, theta), 2))) / 180 * PI;

function find_radians(b, l, radians, n, count = 1) =
    count == n ? radians : (
        find_radians(
            b, 
            l, 
            concat(
                radians, // current angle
                [radians[count - 1] + radian_step(b, radians[count - 1], l)] // angle after rotating
            ), 
            n,
        count + 1)
    );

for(theta = find_radians(b, dot_dist, [init_radian], dots)) {
    rotate(theta * 57.2958) 
        translate([b * theta, 0, 0]) 
            circle(1, $fn = 24);
}
}

dish_x = 2;
dish_z = 1.7;
dish_r_main = 1.6;

module TorusTouch()
{

module Torus(R=100, r=1) {
    rotate_extrude(convexity = 10)
        translate([R, 0, 0])
        circle(r);
}

$fn=72;
top_round = 0.15;
crater_fillet = 0.15;

rim_r = sqrt(dish_r_main * dish_r_main - (dish_z - 0.4) * (dish_z - 0.4));

scale(10)
difference() {
    // 1. MAIN BODY — hull includes a torus at the crater rim
    //    so the cliff edge rolls over smoothly
    hull() {dish_r_main = 1.6;
        cylinder(h=0.1, r=0.55);
        translate([0, 0, 0.3 - top_round])
            rotate_extrude() translate([0.45 - top_round, 0, 0]) circle(r=top_round);
        translate([dish_x, 0, 0])
            cylinder(h=0.1, r=0.35);
        translate([dish_x, 0, 0.4 - top_round])
            rotate_extrude() translate([0.8 - top_round, 0, 0]) circle(r=top_round);
        // Torus at the crater rim — rounds the cliff edge
        translate([dish_x, 0, 0.4 - crater_fillet])
            Torus(R=rim_r + crater_fillet, r=crater_fillet);
    }

    // 2. DISH CUT
    translate([dish_x, 0, dish_z]) {
        hull() {
            sphere(r=dish_r_main);
            translate([0, 0, 0.2])
                sphere(r=1.8);
        }
    }

    // 3. M3 SCREW SINK
    union() {
        translate([0, 0, 0.15])
            cylinder(h=0.3, r=0.351); // M3 washer raidus sized!
        translate([0, 0, -0.1])
            cylinder(h=0.6, r=m3_rad);
    }
}

}

module ArchimedeanSpiralOnSphere(sphere_r = 50)
{
    PI = 3.14159;
    dots = 64;
    dot_dist = 2;
    arm_len = 2;
    init_radian = PI * 2;
    b = arm_len / 2 / PI;

    function r(b, theta) = b * theta;

    function radian_step(b, theta, l) =
        acos((2 * pow(r(b, theta), 2) - pow(l, 2)) / (2 * pow(r(b, theta), 2))) / 180 * PI;

    function find_radians(b, l, radians, n, count = 1) =
        count == n ? radians : (
            find_radians(
                b,
                l,
                concat(
                    radians,
                    [radians[count - 1] + radian_step(b, radians[count - 1], l)]
                ),
                n,
                count + 1)
        );

    // Map a flat 2D spiral point (distance_from_origin, angle) onto a sphere.
    // The flat radial distance becomes the polar angle (arc distance from pole),
    // and the spiral's planar angle becomes the azimuthal angle.
    //
    // flat polar coords:  (rho, phi)  where rho = b*theta, phi = theta
    // sphere mapping:
    //   polar_angle = rho / sphere_r  (arc length -> angle, in radians)
    //   azimuth     = phi
    //
    // Cartesian on sphere (radius sphere_r):
    //   x = sphere_r * sin(polar_deg) * cos(az_deg)
    //   y = sphere_r * sin(polar_deg) * sin(az_deg)
    //   z = sphere_r * cos(polar_deg)
    //
    // Inward normal = -[sin(polar_deg)*cos(az_deg),
    //                   sin(polar_deg)*sin(az_deg),
    //                   cos(polar_deg)]

    function polar_deg(theta) = (b * theta / sphere_r) * 57.2958;
    function az_deg(theta)    = theta * 57.2958;

    function sphere_pos(theta) =
        let(pd = polar_deg(theta), ad = az_deg(theta))
        [ sphere_r * sin(pd) * cos(ad),
          sphere_r * sin(pd) * sin(ad),
          sphere_r * cos(pd) ];

    // Rotation that takes +Z to the inward normal (-radial direction).
    // The inward normal in spherical coords is simply pointing at
    // polar_angle=180+polar_deg, azimuth=az_deg — but easier to
    // just rotate to the radial direction then flip.
    //
    // Strategy: rotate around Z by azimuth, then around Y by polar_angle,
    // then around X by 180° to flip Z inward.

    for (theta = find_radians(b, dot_dist, [init_radian], dots)) {
        pd = polar_deg(theta);
        ad = az_deg(theta);
        pos = sphere_pos(theta);

        translate(pos)
            rotate([0, 0, ad])
            rotate([0, pd, 0])
            rotate([180, 0, 0])   // flip so +Z points inward (toward center)
                // Replace this with whatever object you want on the surface
                cylinder(h = 0.4, r1 = 0.6, r2 = 0.6, $fn = 24);  // small cone pointing inward
    }
}

// Preview: translucent sphere + spiral objects on inside surface
module preview() {
    sphere_r = 50;

    // Show the sphere as a translucent shell for reference
    %difference() {
        sphere(r = sphere_r, $fn = 64);
        sphere(r = sphere_r - 1, $fn = 64);
    }

    ArchimedeanSpiralOnSphere(sphere_r = sphere_r);
}

//preview();


translate([dish_x*10, 0, dish_z*10-0.3]) rotate([0, 180, 0]) ArchimedeanSpiralOnSphere(sphere_r = dish_r_main*10);
TorusTouch();

