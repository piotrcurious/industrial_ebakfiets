include <docs/models/master_dims.scad>
include <docs/models/parts.scad>

// Render with exploded view to check surfaces
union() {
    hub_motor_dd();
    translate([0, 20, 0]) car_rim_half(rim_flange_t);
    mirror([0, 1, 0]) translate([0, 20, 0]) car_rim_half(rim_flange_t);
    rim_fastener_pattern(exploded=0.5);
}
