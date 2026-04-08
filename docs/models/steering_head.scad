include <master_dims.scad>
include <parts.scad>

module steering_head_assy() {
    // 1-1/4" Sch 40 Pipe Housing
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // 7202 Bearings (15x35x11)
    // Positioned inside the ID 35.05mm
    translate([0, 0, head_tube_length/2 - 20]) bearing_7202();
    translate([0, 0, -head_tube_length/2 + 20]) bearing_7202();

    // Internal Collars (Stopping Elements)
    color("silver") {
        translate([0, 0, head_tube_length/2 - 10]) pipe(35, 16, 8);
        translate([0, 0, -head_tube_length/2 + 10]) pipe(35, 16, 8);
    }

    // 15mm Steering Shaft
    color("gray")
    cylinder(d=steering_shaft_dia, h=head_tube_length + 100, center=true);

    // Axial Lock: Shaft Collars
    translate([0, 0, head_tube_length/2 + 10]) shaft_collar_15();
    translate([0, 0, -head_tube_length/2 - 10]) shaft_collar_15();
}

steering_head_assy();
