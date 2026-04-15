include <master_dims.scad>
include <parts.scad>

// FRONT WHEEL - EXPLODED VIEW
// Origin = Axle Center (0,0,0)
module front_wheel_exploded(gap=100) {

    // 1. Central Motor
    hub_motor_dd();

    // 2. Adapters
    for(s=[-1, 1]) translate([0, s * (50 + gap), 0]) rotate([90, 0, 0])
    color(color_brass)
    difference() {
        cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
        cylinder(d=100, h=motor_flange_t+1, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0]) cylinder(d=8.5, h=30, center=true);
        for(a=[0:30:359]) rotate([0, 0, a]) translate([front_hub_flange_dia/2 - 10, 0, 0]) cylinder(d=5.5, h=30, center=true);
    }

    // 3. Rim Halves
    for(s=[-1, 1]) translate([0, s * (50 + gap * 2), 0])
    if (s==1) car_rim_half(); else mirror([0,1,0]) car_rim_half();

    // 4. Tube (Centered, slightly expanded)
    car_tube_13in();

    // 5. Tire (Cutaway or offset)
    translate([0, gap * 3, 0])
    car_tire_13in(alpha=0.4);

    // 6. Fasteners
    rim_fastener_pattern(exploded=gap/50);
}

front_wheel_exploded(80);
