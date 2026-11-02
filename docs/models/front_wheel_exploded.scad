include <master_dims.scad>
include <parts.scad>

// FRONT WHEEL - DETAILED MULTI-COMPONENT EXPLODED VIEW
// Origin = Axle Center (0,0,0)
// Exploded along the Y axle axis to display every constituent part in assembly sequence
module front_wheel_exploded(gap=70) {

    hub_width = 76; // Magic Pie 5 Fatbike hub width

    // 1. Central Motor Stator, Rotor Housing, Axle & Left Brake Rotor
    color(color_fixed) rotate([90, 0, 0]) union() {
        cylinder(d=210, h=hub_width, center=true);
        for(s=[-1,1]) translate([0, 0, s*hub_width/2])
            cylinder(d=front_hub_flange_dia, h=4, center=true);
        for(a=[0:15:359]) rotate([0, 0, a])
            translate([105, 0, 0])
            cube([8, 3, hub_width - 10], center=true);
    }
    // Axle with flats
    color("gray") rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d=front_axle_dia, h=front_hub_dropout + 60, center=true);
            translate([0, 0, -front_hub_dropout/2 - 15]) cylinder(d=25, h=20, center=true);
        }
        for(s=[-1,1]) translate([0, 0, s*(front_hub_dropout/2 + 10)])
            for(side=[-1,1]) translate([side*10, 0, 0]) cube([10, 30, 30], center=true);
    }

    // 2. 203mm Disc Brake Rotor (Exploded outward along -Y)
    translate([0, -gap * 2.8 - (front_hub_dropout/2), 0])
    rotate([90, 0, 0]) color("silver") difference() {
        cylinder(d=203, h=2, center=true);
        for(a=[0:60:359]) rotate([0, 0, a]) translate([22, 0, 0]) cylinder(d=5.5, h=10, center=true);
        cylinder(d=44, h=10, center=true);
    }

    // 3. Motor-to-Rim Adapter Plates (12mm steel plates exploded outward along ±Y)
    for(s=[-1, 1]) translate([0, s * (hub_width/2 + gap * 1.8), 0])
        rotate([90, 0, 0]) color(color_brass) difference() {
            cylinder(d=motor_flange_od, h=motor_flange_t, center=true);
            cylinder(d=105, h=motor_flange_t+1, center=true);
            // Outer 6x M8 holes (260mm PCD)
            for(a=[0:60:359]) rotate([0, 0, a]) translate([rim_bolt_pcd/2, 0, 0]) cylinder(d=8.5, h=30, center=true);
            // Inner 12x M5 holes (320mm PCD)
            for(a=[0:30:359]) rotate([0, 0, a]) translate([front_hub_flange_dia/2 - 10, 0, 0]) cylinder(d=5.5, h=30, center=true);
        }

    // 4. Split Rim Halves (Exploded outward along ±Y)
    for(s=[-1, 1]) {
        translate([0, s * (gap * 1.0), 0])
        color(color_fastener)
        if (s == 1) car_rim_half(); else mirror([0,1,0]) car_rim_half();
    }

    // 5. 13-inch Car Inner Tube with Schrader Valve (Centered)
    car_tube_13in(alpha=0.6);

    // 6. 155/70 R13 Car Tyre (Semi-transparent in place to show internal fitment)
    car_tire_13in(alpha=0.25);

    // 7. M8 Fasteners (Exploded outward along ±Y)
    rim_fastener_pattern(exploded=gap/35);
}

front_wheel_exploded(75);
