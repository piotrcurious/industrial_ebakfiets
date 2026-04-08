include <master_dims.scad>
include <parts.scad>

module frame() {
    // Main Rails
    color("gray") {
        translate([spar_length/2, bed_width_int/2 + 20, 0]) rect_tube(20, 40, spar_length);
        translate([spar_length/2, -bed_width_int/2 - 20, 0]) rect_tube(20, 40, spar_length);
    }

    // Cargo Bed Floor
    color("green", 0.3)
    translate([spar_length - bed_length_int/2, 0, 20]) cube([bed_length_int, bed_width_int, 5], center=true);

    // Head Tube (68 deg angle)
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    pipe(head_tube_od, head_tube_id, head_tube_length);
}

frame();
