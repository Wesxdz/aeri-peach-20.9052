$fn = 256;
// use <your-font-file.ttf> 

// --- Variables ---
spacing_gap = 40; 
all_standoffs = [80, 72, 64, 56, 50, 48, 43, 40, 36];
// Every other standoff: [80, 64, 50, 43, 36]
standoffs = [ for (i = [0 : 2 : len(all_standoffs)-1]) all_standoffs[i] ];

quarter_r = 12.13;

// Colors (R, G, B)
earth_c  = [0.1, 0.4, 0.8]; 
mars_c   = [0.9, 0.3, 0.1]; 
q_color  = [0.75, 0.75, 0.75]; 

// --- Functions ---
function calc_radius(s) = 60 - ((80 - s) / 2);

// Linear Interpolation helper
function lerp(a, b, t) = a + (b - a) * t;

// Spacing logic
function get_x_pos(i) = 
    (i <= 0) ? 0 : 
    (i < len(standoffs)) ? 
        calc_radius(standoffs[i]) + calc_radius(standoffs[i-1]) + spacing_gap + get_x_pos(i-1) :
        quarter_r + calc_radius(standoffs[i-1]) + spacing_gap + get_x_pos(i-1);

// --- Generation: Planets ---
for (i = [0 : len(standoffs) - 1]) {
    s_len = standoffs[i];
    r = calc_radius(s_len);
    
    t = i / (len(standoffs) - 1);
    
    // Explicit RGB mix to avoid parser errors
    current_color = [
        lerp(earth_c[0], mars_c[0], t),
        lerp(earth_c[1], mars_c[1], t),
        lerp(earth_c[2], mars_c[2], t)
    ];

    translate([get_x_pos(i), 0, 0]) {
        color(current_color) sphere(r);
    }
}

// --- Generation: Reference Quarter ---
translate([get_x_pos(len(standoffs)), 0, 0]) {
    color(q_color) sphere(quarter_r);
}