include <master_dims.scad>
use <parts.scad>

// MAIN FRAME ASSEMBLY
// Origin = MATING SURFACE OF THE HEADER PLATE (Gusset face)
// Frame grows in +X from this point.
module frame_assy() {

    // 1. FRAME HEADER PLATE (Mates to Steering Head Gusset)
    color(color_frame)
    translate([5, 0, 0])
    cube([10, 100, head_tube_length - 20], center=true);

    // 2. MAIN SPAR CONNECTIONS
    // Connecting the header plate to the bed rails
    for(s=[-1, 1]) {
        translate([100, s * 40, 0])
        color(color_frame)
        rect_tube(40, 40, 200);
    }

    // 3. CARGO BED CHASSIS
    // Bed starts at x = 200
    translate([bed_length/2 + 200, 0, 0]) {
        // Outer Spars
        for(s=[-1, 1]) {
            translate([0, s * (bed_width/2), 0])
            color(color_frame)
            rect_tube(main_spar_size, main_spar_size, bed_length);
        }

        // Bed Cross-members (Euro-pallet supports)
        for(x=[-bed_length/2 : 400 : bed_length/2])
        translate([x, 0, 0])
        color(color_moving)
        rect_tube(bed_width, 20, 40);

        // Cable guides along left spar
        for(x=[-bed_length/2 + 100 : 300 : bed_length/2])
        translate([x, -bed_width/2 - 10, -10])
        cable_guide();
    }

    // 4. REAR SUBFRAME (Seat & Wheel)
    translate([200 + bed_length + 200, 0, 0]) {
        // Seat tube mast
        translate([-300, 0, 350])
        color(color_subframe)
        pipe(35, 30, 500);

        // Rear dropouts (16" Wheel)
        for(s=[-1, 1]) {
            translate([200, s*70, -100])
            color(color_fastener)
            difference() {
                cube([80, 10, 100], center=true);
                rotate([90, 0, 0]) cylinder(d=10, h=20, center=true);
            }
        }
    }

    // 5. DRIVETRAIN (Bottom Bracket)
    translate([200 + bed_length - 350, 0, 85])
    rotate([90, 0, 0])
    color(color_fastener)
    pipe(40, 34, 68);
}

frame_assy();
