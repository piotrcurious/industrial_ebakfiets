include <master_dims.scad>
include <parts.scad>
include <front_fork.scad>
include <front_wheel_assy.scad>

module front_end_diag() {
    front_wheel_assy();

    alpha = 90 - head_angle;
    rotate([0, -alpha, 0]) {
        front_fork_assy();

        // Current mudguard placement
        rotate([0, alpha, 0])
        mudguard(front_tire_od, mudguard_width_front, 25, 160);
    }
}

front_end_diag();
