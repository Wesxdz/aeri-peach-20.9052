include <render_config.scad>
include <dodecahedroid_config.scad>

module pentagon(size) {
angle = 360 / 5;
points = [
  [size * cos(0), size * sin(0)],
  [size * cos(angle), size * sin(angle)],
  [size * cos(2 * angle), size * sin(2 * angle)],
  [size * cos(3 * angle), size * sin(3 * angle)],
  [size * cos(4 * angle), size * sin(4 * angle)]
];
polygon(points);
}

module PentagonPlate(radius, cell_size, wall_thickness, thickness, border_edge, vent=true, render_color=[1, 0, 0, 0.5]) {

  module chamfered_pentagon(base_radius, top_radius, thickness) {
    sides = 5;

    angles = [for (i = [0:sides-1]) i*(360/sides)];
    base_coords = [for (th=angles) [base_radius*cos(th), base_radius*sin(th), 0]];
    top_coords = [for (th=angles) [top_radius*cos(th), top_radius*sin(th), thickness]];

    faces = [
      [0, 1, 2, 3, 4], // base
      [9, 8, 7, 6, 5], // top (reversed)
      for (i = [0:sides-1]) [i, i+5, (i+1)%sides+5, (i+1)%sides] // sides
    ];
    
    color(render_color)
    polyhedron(points = concat(base_coords, top_coords), faces = faces);
  }
  


  // Hexagon cell
  module hexagon_cell(size, wall_thickness) {
    circle(d = size - wall_thickness, $fn = 6);
  }

  // Hexagon grid
  module hexagon_grid(size, cell_size, wall_thickness) {
    angle = 360 / 5;
    max_radius = size / cos(angle / 2);
    for (x = [-size : cell_size : size]) {
      for (y = [-size : cell_size * sqrt(3) : size]) {
        translate([x, y])
          if (sqrt(x * x + y * y) <= max_radius) {
            rotate([0, 0, 30]) hexagon_cell(cell_size, wall_thickness);
          }
        translate([x + cell_size / 2, y + cell_size * sqrt(3) / 2])
          if (sqrt((x + cell_size / 2) * (x + cell_size / 2) + (y + cell_size * sqrt(3) / 2) * (y + cell_size * sqrt(3) / 2)) <= max_radius) {
            rotate([0, 0, 30]) hexagon_cell(cell_size, wall_thickness);
          }
      }
    }
  }
 
  Z = thickness/tan(116.565/2);
  
  // Chamfered hex vent pentagon
  module panel()
  {
        union()
        {
        difference() {
        chamfered_pentagon(radius, radius-Z, thickness);
        linear_extrude(thickness) pentagon(radius-border_edge);
        }
        difference() {
        linear_extrude(thickness) pentagon(radius-border_edge);
        if (vent && !render_fast_iter)
        {
        linear_extrude(thickness) hexagon_grid(radius, cell_size, wall_thickness);
        }
        }
        }
    }
    panel();
  }
  
//scale(10) PentagonPlate(panel_radius, 0.3, 0.1, panel_thickness, border_edge, true, [0, 1, 1, 1]);