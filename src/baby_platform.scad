// Dodecahedron

include <nutsnbolts/cyl_head_bolt.scad>
include <dodecahedroid_config.scad>
include <rest_composite.scad>
include <psu_mount.scad>

// just got this from Blender stl
connector_height = .252338;
// Polyhedron definition
module DodecahedronSlice() {
    // Constants
    C0 = 0.809016994374947424102293417183;
    C1 = 1.30901699437494742410229341718;
    
    points = [
        [ 0.0,  0.5,   C1],
        [ 0.0,  0.5,  -C1],
        [ 0.0, -0.5,   C1],
        [ 0.0, -0.5,  -C1],
        [  C1,  0.0,  0.5],
        [  C1,  0.0, -0.5],
        [ -C1,  0.0,  0.5],
        [ -C1,  0.0, -0.5],
        [ 0.5,   C1,  0.0],
        [ 0.5,  -C1,  0.0],
        [-0.5,   C1,  0.0],
        [-0.5,  -C1,  0.0],
        [  C0,   C0,   C0],
        [  C0,   C0,  -C0],
        [  C0,  -C0,   C0],
        [  C0,  -C0,  -C0],
        [ -C0,   C0,   C0],
        [ -C0,   C0,  -C0],
        [ -C0,  -C0,   C0],
        [ -C0,  -C0,  -C0]
    ];

    faces = [
        [ 12,  4, 14,  2,  0],
        [ 16, 10,  8, 12,  0],
        [  2, 18,  6, 16,  0],
        [ 17, 10, 16,  6,  7],
        [ 19,  3,  1, 17,  7], // 0
        [  6, 18, 11, 19,  7],
        [ 15,  3, 19, 11,  9],
        [ 14,  4,  5, 15,  9],
        [ 11, 18,  2, 14,  9],
        [  8, 10, 17,  1, 13], // 1
        [  5,  4, 12,  8, 13],
        [  1,  3, 15,  5, 13] // 2
    ];
    
    translate([0, 0, 0]) rotate([-magic_angle, 0, 0]) polyhedron(points, faces);
}

module Sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module PlatformSection(radius, angles, fn)
{
    linear_extrude(0.5)
    Sector(radius, angles, fn);
}

module PiSections()
{
    union()
    {
    color([0.5, 0.0, 1.0, 0.5])
    PlatformSection(30, [30, 150], 24);
    color([1.0, 0.5, 1.0, 0.5])
    PlatformSection(30, [150, 270], 24);
    //color([1.0, 0.0, 0.0, 0.5])
    //PlatformSection(30, [30, -90], 24);
    }
}

module BabyPlatform()
{
    union()
    {
    difference()
    {
    intersection()
    {
    // TODO: Determine the scale relative to panel_radius...
    
    // Inner thickness scale
    union()
    {
    scale(interior_scale) DodecahedronSlice();
    }
    translate([0, 0, to_wheel_mount_surface]) PiSections();//PlatformSection(radius, angles, fn);
    }
    RestHolesComposite();
    }
    // TODO: Split into 3D printed section union module
    RestComposite();
    }
}

difference()
{
rotate([0, 0, 120]) BabyPlatform();
union()
{
import("penta_composite.stl");
$fn = 36;
translate([0, 0, -20]) cylinder(10, 7, 7);
}
}

//translate([-7.5, -7, to_wheel_mount_surface+0.5]) PSUSpec();

//import("penta_composite.stl");

