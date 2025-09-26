module 608Bearing()
{
    $fn=36;
    rotate([90, 0, 0])
    cylinder(.7, 1.1, 1.1);
}

module 626Bearing()
{
    $fn=36;
    rotate([90, 0, 0])
    difference()
    {
    cylinder(.6, 1.9/2, 1.9/2);
    cylinder(.6, 0.6/2, 0.6/2);
    }
}

module 626BearingCutout()
{
    $fn=36;
    scale(1.05) cylinder(.6, 1.9/2, 1.9/2);
}