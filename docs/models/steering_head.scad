include <master_dims.scad>
include <parts.scad>

// STEERING HEAD ASSEMBLY
// Origin = CENTER OF HEAD TUBE (0,0,0)
module steering_head_assy() {
    pipe(head_tube_od, head_tube_id, head_tube_length);
    for(z=[-head_tube_length/2 + 5.5, head_tube_length/2 - 5.5])
    translate([0, 0, z]) color(color_moving) pipe(bearing_od, steering_shaft_dia + 0.5, bearing_h);
    color(color_critical) {
        translate([-head_tube_od/2 - 5, 0, 0]) cube([10, 100, head_tube_length - 20], center=true);
        for(z=[-1, 1]) translate([-head_tube_od/2, 0, z * head_tube_length/2]) rotate([90, 0, 0]) linear_extrude(10, center=true) polygon([[0,0], [-40, 0], [0, -z * 40]]);
    }
    for(s=[-1, 1]) translate([-15, s * 25, -head_tube_length/2]) color("black") cylinder(d=10, h=10);
}
