include <master_dims.scad>
include <parts.scad>

// DIAGNOSTIC DRIVER
module tire_rim_check() {
    %car_tire_13in();
    car_rim_13in_split();
}

tire_rim_check();
