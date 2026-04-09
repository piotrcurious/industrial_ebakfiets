include <master_dims.scad>
use <parts.scad>

// STEERING HEAD ASSEMBLY
// Origin = CENTER OF HEAD TUBE (0,0,0)
module steering_head_assy() {
    // 1. MAIN HEAD TUBE (1-1/4" Sch 40)
    color("firebrick")
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // 2. BEARING SEATS (Internal)
    for(z=[-head_tube_length/2 + 5.5, head_tube_length/2 - 5.5])
    translate([0, 0, z])
    color("blue")
    pipe(bearing_od, steering_shaft_dia + 0.5, bearing_h);

    // 3. CHASSIS GUSSET PLATE (Mating surface for the Frame)
    // This is the "Header Plate" that the frame rails weld to.
    translate([-head_tube_od/2 - 5, 0, 0])
    color("firebrick")
    cube([10, 100, head_tube_length - 20], center=true);

    // 4. STEERING STOPS
    for(s=[-1, 1])
    translate([-15, s * 25, -head_tube_length/2])
    color("black")
    cylinder(d=10, h=10);
}

steering_head_assy();
