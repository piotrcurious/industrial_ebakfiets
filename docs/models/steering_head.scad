include <master_dims.scad>
include <parts.scad>

// STEERING HEAD ASSEMBLY
// Origin = CENTER OF HEAD TUBE (0,0,0)
module steering_head_assy() {
    // 1. MAIN HEAD TUBE (1-1/4" Sch 40)
    color(color_critical)
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // 2. BEARING SEATS (Internal)
    for(z=[-head_tube_length/2 + 5.5, head_tube_length/2 - 5.5])
    translate([0, 0, z])
    color(color_moving)
    pipe(bearing_od, steering_shaft_dia + 0.5, bearing_h);

    // 3. CHASSIS GUSSET PLATE (Mating surface for the Frame)
    // This is the "Header Plate" that the frame rails weld to.
    color(color_critical) {
        translate([-head_tube_od/2 - 5, 0, 0])
        cube([10, 100, head_tube_length - 20], center=true);

        // Reinforcing Gussets (Top and Bottom)
        for(z=[-1, 1]) translate([-head_tube_od/2, 0, z * head_tube_length/2])
        rotate([90, 0, 0])
        linear_extrude(10, center=true)
        polygon([[0,0], [-40, 0], [0, -z * 40]]);
    }

    // 4. STEERING STOPS
    for(s=[-1, 1])
    translate([-15, s * 25, -head_tube_length/2])
    color("black")
    cylinder(d=10, h=10);
}
