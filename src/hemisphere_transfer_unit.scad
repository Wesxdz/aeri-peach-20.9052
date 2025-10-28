include <nutsnbolts/cyl_head_bolt.scad>;

module Hemisphere(radius, half_sep)
{
    $fn=128;
    difference()
    {
        color([0.0, 1.0, 0.5, 0.5])
        sphere(radius);
        translate([-radius, -half_sep, -radius]) cube([radius*2, radius*2, radius*2]);
    }
}

module BallBearing608()
{
    $fn=36;
    rotate([90, 0, 0])
    cylinder(.7, 1.1, 1.1);
}

module BowlVolume(sphere_radius = 1.1, bearing_radius=0.15)
{
    bottom_height = 0.35;
    edge_thickness = 1.5;
    bowl = (sphere_radius+(bearing_radius*2));
    $fn=36;
    color([0.0, 0.0, 1.0, 0.5])
    translate([0, 0, bottom_height + bowl]) sphere(sphere_radius+bearing_radius);
}


module SphereVolume(sphere_radius = 1.1, bearing_radius=0.15)
{
    bottom_height = 0.35;
    edge_thickness = 1.5;
    bowl = (sphere_radius+(bearing_radius*2));
    $fn=36;
    color([0.0, 0.0, 1.0, 0.5])
    translate([0, 0, bottom_height + bowl]) sphere(sphere_radius+0.07); // buffer for sealing
}

module BallTransferUnit(sphere_radius = 1.1, bearing_radius=0.15, bottom_height = 0.15, hemisphere_slot=false)
{
    outer_loop_height = 0.5;
    inner_edge = 0.5;
    edge_thickness = 1.5;
    middle_edge = inner_edge + (edge_thickness-inner_edge)/2;
    bowl = (sphere_radius+(bearing_radius*2));
    difference()
    {
    union()
    {
    difference()
    {
    union()
    {
    $fn=36;
    translate([0, 0, bowl]) sphere(sphere_radius);
    difference()
    {
        
        union()
        {
        up = bowl-((bowl+bottom_height)/2);
        translate([0, 0, up]) cylinder(bowl+bottom_height, bowl+inner_edge, bowl+inner_edge, center=true);
        translate([0, 0, (bottom_height+outer_loop_height)/2 + (up-((bowl+bottom_height)/2))]) cylinder(bottom_height+outer_loop_height, bowl+edge_thickness, bowl+edge_thickness, center=true);
        }
        if (!hemisphere_slot)
        {
        $fn=36;
        translate([0, 0, bowl]) sphere(sphere_radius+bearing_radius*2);
        }
    }
    }
    }
//    for (i=[0:4])
//    {
//        catch_offset = bowl/2+0.24;
//        $fn = 36; // 2.3
//        translate([0, 0, -(bowl+bottom_height)/2 + (bottom_height+outer_loop_height)/2 - 0.2]) translate([catch_coords[i][0], catch_coords[i][1], 0]) scale(0.1) rotate([0, 180, 0]) screw("M3x30");
//    }

    }
    screw_radius = bowl + middle_edge;
    catch_start_radius = bowl + middle_edge;
    cliff_start_radius = bowl + middle_edge - .15;
    angles = [for (z = [0:4]) (360/4 * z)];
    base_coords = [for (th=angles) [screw_radius*cos(th), screw_radius*sin(th), 0]];
    catch_coords = [for (th=angles) [catch_start_radius*cos(th), catch_start_radius*sin(th), 0]];
    cliff_coords_coords = [for (th=angles) [cliff_start_radius*cos(th), cliff_start_radius*sin(th), 0]];
    for (i=[0:4])
    {
        $fn = 36;
        hull()
        {
        up = bowl-((bowl+bottom_height)/2);
        // .24
        catch_offset = (bottom_height+outer_loop_height)/2 + (up-((bowl+bottom_height)/2)) + (bottom_height+outer_loop_height)/2;
        translate([0, 0, catch_offset]) translate([base_coords[i][0], base_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
        translate([0, 0, catch_offset]) translate([cliff_coords_coords[i][0], cliff_coords_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
        }
    }
    }
}

module BallTransferAttachment(sphere_radius = 1.1, bearing_radius=0.15, bottom_height = 0.35, hemisphere_slot=false)
{
    outer_loop_height = 0.5;
    inner_edge = 0.5;
    edge_thickness = 1.5;
    bowl = (sphere_radius+(bearing_radius*2));
    screw_radius = sphere_radius + bearing_radius + edge_thickness/3+0.25;
    catch_start_radius = sphere_radius + bearing_radius  + edge_thickness/3;
    cliff_start_radius = sphere_radius + bearing_radius  + edge_thickness/3+0.125;
    angles = [for (z = [0:4]) (360/4 * z)];
    base_coords = [for (th=angles) [screw_radius*cos(th), screw_radius*sin(th), 0]];
    catch_coords = [for (th=angles) [catch_start_radius*cos(th), catch_start_radius*sin(th), 0]];
    cliff_coords_coords = [for (th=angles) [cliff_start_radius*cos(th), cliff_start_radius*sin(th), 0]];
for (i=[0:4])
{
    $fn = 36;
    hull()
    {
    catch_offset = bowl+0.24+0.12; // -(.35-.24) + 
    translate([0, 0, catch_offset]) translate([base_coords[i][0], base_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
    translate([0, 0, catch_offset]) translate([catch_coords[i][0], catch_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
    }
}

for (i=[0:4])
{
    $fn = 36;
    hull()
    {
    catch_offset = bowl-1+0.24; // -(.35-.24) + 
    translate([0, 0, catch_offset]) translate([base_coords[i][0], base_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
    translate([0, 0, catch_offset]) translate([cliff_coords_coords[i][0], cliff_coords_coords[i][1], 0.0]) scale(0.1) nutcatch_parallel("M3");
    }
}

for (i=[0:4])
{
    catch_offset = bowl/2+0.24;
    $fn = 36;
    translate([0, 0, catch_offset]) translate([catch_coords[i][0], catch_coords[i][1], -1]) scale(0.1) rotate([0, 180, 0]) screw("M3x16");
}
}

module SphereExit(radius, separation, roller_radius, bearing_radius)
{
union()
{
rotate([90, 0, 0]) translate([0, 0, -(roller_radius*2+bearing_radius+0.35) + radius]) SphereVolume();
translate([0, -4*2+0.2, 0]) cube([4*2, 4*2, 4*2], center=true);
}
}

module HemisphereMechanism(radius, separation, roller_radius, bearing_radius)
{
standard_z_offset = -(roller_radius*2+bearing_radius+0.35) + radius;
union()
{
difference()
{
Hemisphere(radius, separation);
union()
{
translate([0, -radius*2 + bearing_radius, 0]) cube([radius*2, radius*2, radius*2], center=true);
rotate([90, 0, 0]) translate([0, 0, standard_z_offset ]) BowlVolume();
}
}

difference()
{
difference()
{
intersection()
{
translate([0, -radius*2 + bearing_radius*2, 0]) cube([radius*2, radius*2, radius*2], center=true);
rotate([90, 0, 0]) translate([0, 0, standard_z_offset]) BowlVolume();
}
intersection()
{
translate([0, -4*2 + 0.15, 0]) cube([4*2, 4*2, 4*2], center=true);
rotate([90, 0, 0]) translate([0, 0, standard_z_offset]) BowlVolume();
}
}
rotate([90, 0, 0]) translate([0, 0, standard_z_offset]) SphereVolume();
}

}
}

module HemisphereSkeleton(radius, separation, roller_radius=1.1, bearing_radius=0.15)
{
rotate([90, 0, 0]) translate([0, 0, separation-(roller_radius*2+bearing_radius+0.35) + (radius-separation)]) BallTransferUnit(roller_radius, bearing_radius);
}

module HemisphereDiff(radius, separation, roller_radius=1.1, bearing_radius=0.15)
{
difference()
{
    HemisphereTransferUnit(radius, separation, roller_radius, bearing_radius);
    union()
    {
    rotate([90, 0, 0]) translate([0, 0, separation-(roller_radius*2+bearing_radius+0.35) + (radius-separation)]) BallTransferUnit(roller_radius, bearing_radius, 4.0, true);
    
    rotate([90, 0, 0]) translate([0, 0, separation-(roller_radius*2+bearing_radius+0.35) + (radius-separation)]) BallTransferAttachment(roller_radius, bearing_radius, 4.0, true);
    }   
}
}

module HemisphereTransferUnit(radius, separation, roller_radius=1.1, bearing_radius=0.15)
{
union()
{
difference()
{
HemisphereMechanism(radius, separation, roller_radius, bearing_radius);
SphereExit(radius, separation, roller_radius, bearing_radius);
}
// (4.0-(1.1+0.15)*2-0.35)
rotate([90, 0, 0]) translate([0, 0, separation-(roller_radius*2+bearing_radius+0.35) + (radius-separation)]) BallTransferUnit();
}
}

//HemisphereSkeleton(4, 0.1);
//HemisphereDiff(4, 0.1);
// rotate([90, 0, 0]) translate([0, 0, separation-(roller_radius*2+bearing_radius+0.35) + (radius-separation)]) BallTransferUnit();

//BallTransferUnit();

//HemisphereTransferUnit(4, 0.1);

//difference()
//{
//intersection()
//{
//rotate([90, 0, 0]) translate([0, 0, 0.1-((1.1)*2+0.15+0.35) + 3.9]) BowlVolume();
//translate([0, -4*2 + 0.15, 0]) cube([4*2, 4*2, 4*2], center=true);
//}
//rotate([90, 0, 0]) translate([0, 0, 0.1-((1.1)*2+0.15+0.35) + 3.9]) BowlVolume(1.1-0.15);
//}
//for (i=[0:5])
//{
//    base_radius = i/5*sphere_radius;
//    angles = [for (z = [1:1+i*2]) z*(360/(1+i*2))];
//    base_coords = [for (th=angles) [(base_radius+0.15)*cos(th), (base_radius+0.15)*sin(th), ((base_radius) * sin(i*(90/10)))]];
//    for (j=[0:len(angles)-1])
//    {
//        translate([base_coords[j][0], base_coords[j][1], sphere_radius-base_coords[j][2]]) sphere(0.15);
//    }
//}