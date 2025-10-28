translate([0, 0, 29]) import ("dodecahedroid.stl");

module TelescopeRod()
{
    cylinder(150, 2, 2, 
    $fn=36);
}

module TelescopeRod(contracted_height, sections=1, section_height)
{
    
    cylinder(150, 2, 2, 
    $fn=36);
}

module HumanSizeCapsule()
{
    translate([0, 0, 37/2])
    hull()
    {   
        $fn=36;
        sphere(37/2);
        translate([0, 0, 9.4+45+46-37/2]) 
        {
        sphere(37/2);
            translate([0, 0, 48.8]) 
            {
                sphere(46/2);
                translate([0, 0, 38]) 
                {
                    sphere(16.9/2);
                }
            }
        }
    }
}

translate([0, 0, 54])TelescopeRod();
translate([100, 0, 0]) HumanSizeCapsule();