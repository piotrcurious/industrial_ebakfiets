include <master_dims.scad>
include <parts.scad>

// FRONT WHEEL - EXPLODED VIEW
// Origin = Axle Center (0,0,0)
module front_wheel_exploded(gap=100) {

    // 1. Central Motor Housing & Axle
    hub_width = 76;
    color(color_fixed) rotate([90, 0, 0]) union() {
        cylinder(d=210, h=hub_width, center=true);
        for(s=[-1,1]) translate([0, 0, s*hub_width/2])
            cylinder(d=front_hub_flange_dia, h=4, center=true);
        for(a=[0:15:359]) rotate([0, 0, a])
            translate([105, 0, 0])
            cube([8, 3, hub_width - 10], center=true);
    }
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            translate([0, 0, -front_hub_dropout/2 - 15]) cylinder(d=25, h=20, center=true);
        }
        for(s=[-1,1]) translate([0, 0, s*(front_hub_dropout/2 + 10)])
            for(side=[-1,1]) translate([side*10, 0, 0]) cube([10, 30, 30], center=true);
    }

    // 2. Adapters (Exploded)
    for(s=[-1, 1]) translate([0, s * (rim_flange_t + gap), 0]) rotate([90, 0, 0])
    color(color_brass)
    difference() {
        cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
        cylinder(d=105, h=motor_flange_t+1, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0]) cylinder(d=8.5, h=30, center=true);
        for(a=[0:30:359]) rotate([0, 0, a]) translate([front_hub_flange_dia/2 - 10, 0, 0]) cylinder(d=5.5, h=30, center=true);
    }

    // 3. Rim Halves (Exploded)
    for(s=[-1, 1]) translate([0, s * (rim_flange_t + gap * 2), 0])
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
