include <master_dims.scad>
use <parts.scad>

// The Frame connects the Head Tube to the Rear Wheel and Bed.
// Origin = Mating surface with the Steering Head Gusset.
// The frame grows in the POSITIVE X direction from this surface.
module frame_assy() {
    // 1. Connection Member (Gusset to Bed)
    // Connecting to a gusset that is 20mm thick.
    color("darkblue")
    translate([50, 0, 0])
    rect_tube(80, 80, 100);

    // 2. Cargo Bed Rails
    // Bed starts at x=100
    translate([bed_length/2 + 100, 0, 0]) {
        for(s=[-1, 1]) {
            translate([0, s * (bed_width/2), 0])
            color("darkblue")
            rect_tube(main_spar_size, main_spar_size, bed_length);
        }

        // Bed Cross-members
        for(x=[-bed_length/2 : 400 : bed_length/2])
        translate([x, 0, 0])
        color("royalblue")
        rect_tube(bed_width, 20, 40);
    }

    // 3. Rear End
    // Extends from the end of the bed (x = 100 + bed_length)
    translate([100 + bed_length + 150, 0, 0]) {
        // Seat tube mast
        translate([-250, 0, 300])
        color("darkblue")
        pipe(35, 30, 400);

        // Rear dropouts
        for(s=[-1, 1]) {
            translate([150, s*70, -100])
            color("silver")
            cube([60, 10, 80], center=true);
        }
    }

    // 4. Bottom Bracket Shell
    translate([100 + bed_length - 300, 0, 50])
    rotate([90, 0, 0])
    color("silver")
    pipe(40, 34, 68);
}

frame_assy();
