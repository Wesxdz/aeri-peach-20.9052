// Welcome dodecahedroid
include <dodecahedroid_config.scad>

include <pentagon_plate.scad>
include<connector_pentagon_plate.scad>
include <wheel_panel.scad>
include <custom_plate.scad>

module RestComposite()
{
panel_rots = [36, -36*4.5, 0, 18, 180+36, -18, 18, -18, 18, 18+72, 18, -36];

// 0 is Nose Cone
// 1 is Bridge
// 2 is Life Support
// 3 is Cradle
groups = [0, 1, 0, 1, 3, 2, 2, 2, 0, 3, 1, 3];

// 0 Back upper left
// 1 Front
// 2 Back upper right
// 3 Side right
// 4 Bottom right (right back wheel)
// 5 Back right
// 6 Back (power port)
// 7 Back left
// 8 Back middle upper
// 9 Front lower (front wheel)
// 10 Side left
// 11 Bottom left (left back wheel)

C1 = 1.30901699437494742410229341718;

color([.5, .5, .5, .2])
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) {
    if (groups[i] == 3) // Render only base
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    RestPrefab(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, [0.0, 1.0, 1.0, 0.6], true);
    }
    }
}
}

module RestHolesComposite()
{
panel_rots = [36, -36*4.5, 0, 18, 180+36, -18, 18, -18, 18, 18+72, 18, -36];

// 0 is Nose Cone
// 1 is Bridge
// 2 is Life Support
// 3 is Cradle
groups = [0, 1, 0, 1, 3, 2, 2, 2, 0, 3, 1, 3];

// 0 Back upper left
// 1 Front
// 2 Back upper right
// 3 Side right
// 4 Bottom right (right back wheel)
// 5 Back right
// 6 Back (power port)
// 7 Back left
// 8 Back middle upper
// 9 Front lower (front wheel)
// 10 Side left
// 11 Bottom left (left back wheel)

C1 = 1.30901699437494742410229341718;

color([.5, .5, .5, .2])
rotate([-magic_angle, 0, 0])
{
for (i = [0 : len(pos)-1]) {
    if (groups[i] == 3) // Render only base
    {
    translate(pos[i]*panel_edge_length) rotate(rots[i]) rotate([0, 0, panel_rots[i]])
    RestPrefabHoles(panel_radius, cell_size, wall_thickness, panel_thickness, border_edge, false, [0.0, 1.0, 1.0, 0.6]);
    }
    }
}
}

//RestComposite();