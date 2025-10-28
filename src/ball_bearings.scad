module BallBearing608()
{
    $fn=36;
    rotate([90, 0, 0])
    cylinder(.7, 1.1, 1.1);
}

module BallBearing626()
{
    $fn=36;
    rotate([90, 0, 0])
    difference()
    {
    cylinder(.6, 1.9/2, 1.9/2);
    cylinder(.6, 0.6/2, 0.6/2);
    }
}

module BallBearing626Cutout()
{
    $fn=36;
    scale(1.05) cylinder(.6, 1.9/2, 1.9/2);
}