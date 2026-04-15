include <master_dims.scad>
include <parts.scad>

// FRONT WHEEL - X-RAY / ASSEMBLY VIEW
module front_wheel_xray() {
    // Solid Internal Mechanics
    hub_motor_dd();
    car_rim_13in_split();
    rim_fastener_pattern();

    // Translucent Rubber Components
    car_tube_13in(alpha=0.6);
    car_tire_13in(alpha=0.3);
}

front_wheel_xray();
