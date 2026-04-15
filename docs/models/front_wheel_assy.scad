include <master_dims.scad>
include <parts.scad>

// COMPLETE FRONT WHEEL ASSEMBLY
// Origin = Axle Center (0,0,0)
module front_wheel_assy() {
    car_tire_13in();
    car_rim_13in_split();
    rim_fastener_pattern();
    hub_motor_dd();
}
