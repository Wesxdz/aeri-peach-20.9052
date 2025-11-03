include <bend/bend.scad>
include <dodecahedroid_config.scad>
include <ball_bearings.scad>

    // Cut plane - keeps only the latter half
    
    // Straight bottom half
module Shield() {
scale(0.1)
{
    difference()
    {
    linear_extrude(mounted_wheel_depth*10) 
        import("omni_support_surve.svg");
    translate([0, 50, 0])
    cube([100, 100, 100]);
    }
    
    // Curved top half
    intersection()
    {
    
    translate([0, 50, 0])
    parabolic_bend([100, 100, 15], 0.004)
    translate([0, -50, 0])
    difference()
    {
    linear_extrude(mounted_wheel_depth*10) import("omni_support_surve.svg");
    union()
    {
    translate([0, -50, 0]) cube([100, 100, 100]);
    //translate([0, -60, 0]) cube([100, 100, 100]);
    }
    }

    linear_extrude(40) 
        import("omni_support_surve.svg");
    
    }
}
}

//minkowski()
//{
//Shield();
//sphere(r=5);
//}

module ShieldBrace()
{
    difference()
    {
    Shield(); translate([2.5, 3.3, 0])BallBearing626Cutout();
    }
}

//ShieldBrace();