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
    // Refined geometry: Triple-point hull for organic taper and structural rigidity
    color(color_frame)
    for(s=[-1, 1]) {
        hull() {
            // Top attachment at Header Plate (Beefy junction)
            translate([10, s * 40, 0])
            sphere(d=50);

            // Midpoint (Defining the neck curvature)
            translate([riser_length/2, s * (bed_internal_width/6), -riser_drop/2])
            sphere(d=45);

            // Bottom attachment at Bed start (Spreads load across spar)
            translate([riser_length, s * (bed_width/2 - 20), -riser_drop])
            sphere(d=main_spar_size + 10);
        }
    }

    // 3. REAR CHASSIS (Starts after riser)
    translate([riser_length, 0, -riser_drop]) {

        // A. Cargo Bed
        translate([bed_length/2, 0, 0]) {
            // Outer Spars
            for(s=[-1, 1]) {
                translate([0, s * (bed_width/2 - main_spar_size/2), 0])
                color(color_frame)
                rect_tube(main_spar_size, main_spar_size, bed_length);
            }

            // Bed Cross-members (Euro-pallet supports)
            for(x=[-bed_length/2 + 20 : 400 : bed_length/2 - 20])
            translate([x, 0, 0])
            color(color_moving)
            rect_tube(bed_width - 2*main_spar_size, 20, 40);

            // Cable guides along left spar
            for(x=[-bed_length/2 + 100 : 300 : bed_length/2])
            translate([x, -bed_width/2 - 10, -10])
            cable_guide();
        }

        // B. Rear Subframe (Seat & Wheel)
        // Transition from wide bed to narrow rear wheel (135mm dropout spacing)
        for(s=[-1, 1]) {
            color(color_frame)
            hull() {
                // Wide Bed End
                translate([bed_length, s * (bed_width/2 - main_spar_size/2), 0])
                cube([main_spar_size, main_spar_size, main_spar_size], center=true);

                // Narrow Dropout Top
                translate([bed_length + 200, s * (135/2 + 5), -50])
                cube([20, 10, 20], center=true);
            }
        }

        translate([bed_length + 200, 0, 0]) {
            // Seat tube mast - connected to bed end via bridge
            translate([-300, 0, 350])
            color(color_subframe)
            pipe(35, 30, 500);

            // Bridge to seat mast
            translate([-300, 0, 100])
            color(color_frame)
            rotate([0, 90, 0]) pipe(40, 35, 200);

            // Rear dropouts (16" Wheel)
            for(s=[-1, 1]) {
                translate([0, s*(135/2 + 5), -100])
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
        pipe(40, 34, 68); // Standard BB shell
    }
}

frame_assy();
