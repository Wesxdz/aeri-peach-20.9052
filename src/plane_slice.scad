module slice_above(height = 0, size = 1000) {
    difference() {
        children();
        translate([-size/2, -size/2, height])
            cube([size, size, size]);
    }
}

// Usage:
slice_above(height = 20) {
    sphere(r = 50);
}