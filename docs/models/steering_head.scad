include <master_dims.scad>
include <parts.scad>

// STEERING HEAD ASSEMBLY
// Origin = CENTER OF HEAD TUBE (0,0,0)
module steering_head_assy() {
    // Main Pipe
    color(color_frame) pipe(head_tube_od, head_tube_id, head_tube_length);

    // Internal Bearings (7202)
    for(z=[-head_tube_length/2 + 5.5, head_tube_length/2 - 5.5])
    translate([0, 0, z]) color(color_brass) pipe(bearing_od, steering_shaft_dia + 0.5, bearing_h);

    // Structural Gusset Plate
    color(color_critical) {
        translate([-head_tube_od/2 - 6, 0, 0]) rounded_box([12, 110, head_tube_length - 30], r=3, center=true);
        // Reinforcing Fins
        for(z=[-1, 1]) translate([-head_tube_od/2, 0, z * head_tube_length/2])
        rotate([90, 0, 0]) linear_extrude(12, center=true)
        polygon([[0,0], [-50, 0], [0, -z * 50]]);
    }

    // Steering Stop Pins
    for(s=[-1, 1]) translate([-20, s * 30, -head_tube_length/2])
    color("dimgray") cylinder(d=12, h=15);
}
