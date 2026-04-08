include <master_dims.scad>
include <parts.scad>

module frame_assy() {
    // Main Rails (40x20)
    color("gray") {
        translate([spar_length/2, bed_width_int/2 + 20, 0]) rect_tube(20, 40, spar_length);
        translate([spar_length/2, -bed_width_int/2 - 20, 0]) rect_tube(20, 40, spar_length);
    }

    // Head Tube (68 deg)
    translate([spar_length, 0, 150])
    rotate([0, 90-head_angle, 0])
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // BB Shell bridge
    translate([bb_x_offset, 0, 85])
    color("darkgray")
    pipe(40, 34, 100);
}

frame_assy();
