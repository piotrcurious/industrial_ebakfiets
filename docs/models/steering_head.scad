include <parts.scad>

module steering_head() {
    // 1-1/4" Sch 40 Pipe
    pipe(42.16, 35.05, 200);

    // 7202 Bearings (15x35x11)
    translate([0, 0, 80]) bearing_7202();
    translate([0, 0, -80]) bearing_7202();

    // 15mm Steering Shaft
    color("gray")
    cylinder(d=15, h=300, center=true, $fn=64);

    // Stopping Collars (35mm OD)
    color("silver") {
        translate([0, 0, 90]) pipe(35, 16, 8);
        translate([0, 0, -90]) pipe(35, 16, 8);
    }
}

steering_head();
