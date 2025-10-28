include <gt2_20_pulley.scad>
// https://www.youtube.com/watch?v=Oagdn4FSCkE
// Pulley pitch diameters GT2 20T
D1 = 1.27;  // larger diameter
D2 = 1.27;  // smaller diameter
// Fixed belt length
L = 20.0;

function belt_center_distance(L, D, d) = 
    let(
        B = L - (PI/2)*(D + d),
        discriminant = B*B - 2*(D - d)*(D - d)
    )
    discriminant >= 0 
        ? (B + sqrt(discriminant)) / 4
        : undef;

C = belt_center_distance(L, D1, D2);
echo("Center distance C:", C);

module PulleyMockup(D1, D2, L, C, belt_width, belt_depth)
{
    $fn=128;
    linear_extrude(belt_width)
    {
        difference()
        {
        hull()
        {
            circle(D1/2+0.001);
            translate([C, 0, 0]) circle(D2/2+0.001);
        }
        hull()
        {
            circle(D1/2-belt_depth);
            translate([C, 0, 0]) circle(D2/2-belt_depth);
        }
        }
    }
}

//translate([0, 0, 0.85]) scale(0.1) color([1, 0.5, 0.2]) PulleyMockup(D1, D2, L, C, 6, 0.1);