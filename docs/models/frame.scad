include <master_dims.scad>
include <parts.scad>

// MAIN FRAME ASSEMBLY
// Origin = MATING SURFACE OF THE HEADER PLATE (Gusset face)
// Frame grows in +X from this point.
module frame_assy() {

    // 1. FRAME HEADER PLATE (Mates to Steering Head Gusset)
    color(color_frame)
    translate([5, 0, 0])
    cube([10, 100, head_tube_length - 20], center=true);

    // 2. GOOSENECK RISER (Transition from Head Tube to Low Bed)
    // Drops from steering head height to ground_clearance + spar_size/2
    // Steering head center is at approx 500mm above axle (774mm above ground)
    // Bed center is at 150 + 20 = 170mm above ground.
    // Drop is approx 600mm.
    riser_drop = 500; // Calculated drop from header center to bed center
    riser_length = 400;

    color(color_frame)
    for(s=[-1, 1]) {
        hull() {
            // Top attachment at Header Plate
            translate([10, s * 40, 0])
            cube([20, 40, 40], center=true);

            // Bottom attachment at Bed start
            translate([riser_length, s * (bed_width/4), -riser_drop])
            cube([40, 40, 40], center=true);
        }

        // Reinforcing Gussets for Riser
        translate([riser_length/2, s * 40, -riser_drop/2])
        rotate([0, -atan2(riser_drop, riser_length), 0])
        rect_tube(10, 80, sqrt(riser_drop*riser_drop + riser_length*riser_length));
    }

    // 3. REAR CHASSIS (Starts after riser)
    translate([riser_length, 0, -riser_drop]) {

        // A. Cargo Bed
        translate([bed_length/2, 0, 0]) {
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

        // B. Rear Subframe (Seat & Wheel)
        // Adjusted relative to bed end
        translate([bed_length + 200, 0, 0]) {
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

        // C. Bottom Bracket (Drivetrain Anchor)
        translate([bed_length - 150, 0, 85])
        rotate([90, 0, 0])
        color(color_fastener)
        pipe(40, 34, 68);
    }
}

frame_assy();
