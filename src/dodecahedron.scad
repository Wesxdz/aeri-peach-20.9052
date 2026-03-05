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

rotate([-20.9052*1.5, 0, 15])
dodecahedron(20);