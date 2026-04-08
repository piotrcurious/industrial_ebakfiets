include <master_dims.scad>
include <parts.scad>

module steering_head() {
    // Sch 40 Housing
    color("gray", 0.5)
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // Stop Elements
    color("silver") {
        translate([0, 0, head_tube_length/2 - 10]) pipe(head_tube_id, steering_shaft_dia + 1, 8);
        translate([0, 0, -head_tube_length/2 + 10]) pipe(head_tube_id, steering_shaft_dia + 1, 8);
    }

    // Bearings
    translate([0, 0, head_tube_length/2 - 20]) bearing_7202();
    translate([0, 0, -head_tube_length/2 + 20]) bearing_7202();

    // Shaft
    color("dim gray")
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100, center=true);
}

steering_head();
