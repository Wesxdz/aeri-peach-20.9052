// https://bulkman3d.com/product/gt0002-20/
module GT2_20_Pulley(bore_size=6, belt_width=6)
{
    scale(0.1)
    {
    height = belt_width + 10;
    $fn=64;
    difference()
    {
        union()
        {
            cylinder(8, 8, 8);
            cylinder(height, 6, 6);
            translate([0, 0, height-1]) cylinder(1, 8, 8);
        }
        cylinder(20, bore_size/2, bore_size/2);
    }
    }
}

//GT2_20_Pulley();

// 5mm-20T-6mm-GT2-Pulley-W-Beari-2.jpg?v=1724433988
module GT2_20_IdlePulley(bore_size=5, belt_width=6)
{
    scale(0.1)
    {
    height = belt_width + 3;
    $fn=64;
    difference()
    {
        union()
        {
            cylinder(1, 9, 9);
            cylinder(height, 9/2, 9/2);
            translate([0, 0, height-1]) cylinder(1, 9, 9);
        }
        cylinder(20, bore_size/2, bore_size/2);
    }
    }
}

