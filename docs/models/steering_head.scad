include <master_dims.scad>
use <parts.scad>

// The Steering Head houses the shaft and connects to the Frame.
// Origin = Center of Head Tube
module steering_head_assy() {
    // 1. Main Head Tube
    color("firebrick")
    pipe(head_tube_od, head_tube_id, head_tube_length);

    // 2. Bearings (Top and Bottom)
    for(z=[-head_tube_length/2 + 10, head_tube_length/2 - 10])
    translate([0, 0, z])
    color("blue")
    pipe(bearing_od, steering_shaft_dia + 0.5, 11);

    // 3. Frame Connection Gusset (Surface for Frame spars)
    // Centered on the HT
    translate([-head_tube_od/2 - 10, 0, 0])
    color("firebrick")
    cube([20, 60, head_tube_length - 40], center=true);
}

steering_head_assy();
