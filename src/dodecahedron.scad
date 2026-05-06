include <dodecahedron_config.scad> 

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

// just got this from Blender stl
connector_height = .252338;
// Polyhedron definition
module Dodecahedron(bot_offset = 0.0) {
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

    // Render polyhedron
    difference()
    {
    // if it were a cube, we'd rotate 45
    // however it's a dodecahedron
    // so we use tetrahedron angle C
    // 0.09224 is an approximation, since I'm not sure how to calculate this easily
    translate([0, 0, C1-.088]) rotate([-magic_angle, 0, 0]) polyhedron(points, faces);
    s = 50;
    translate([-s/2, -s/2, bot_offset]) cube([s,s,10]);
    }
    //for (f = [0 : len(faces)-1]) {
for (f = [0 : 0]) {
    center = [0.0, 0.0, 0.0];
    echo(center);
    for (v = [0 : len(faces[f])-1]) {
        echo("Index:", faces[f][v]);
        echo("Point:", points[faces[f][v]]);
        center = center + points[faces[f][v]];
        echo(center);
    }
    echo(center);
}
}

// rotate([-20.9052*1.5, 0, 15])
// dodecahedron(20);