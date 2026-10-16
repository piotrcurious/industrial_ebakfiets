include <master_dims.scad>
include <parts.scad>

// FRONT WHEEL - EXPLODED VIEW
// Origin = Axle Center (0,0,0)
module front_wheel_exploded(gap=80) {

    hub_width = 76;

    // 1. Central Motor Housing & Axle
    hub_motor_dd();

    // 2. Tube & Tire (Offset along Z or transparent)
    car_tube_13in(alpha=0.3);
    car_tire_13in(alpha=0.3);

    // 3. Exploded Rim Halves
    for(s=[-1, 1]) {
        translate([0, s * gap, 0])
        if (s == 1) car_rim_half(); else mirror([0,1,0]) car_rim_half();
    }

    // 4. Fastener Pattern (Exploded along Y)
    rim_fastener_pattern(exploded=gap/40);
}

front_wheel_exploded(80);
