include <master_dims.scad>
use <parts.scad>

// The Front Wheel assembly
module wheel_assy() {
    // 1. 13" Car Tire
    car_tire_13in();

    // 2. Hub Motor
    front_hub_motor();
}

wheel_assy();
