include <master_dims.scad>
include <parts.scad>

// MAIN FRAME ASSEMBLY
// Origin = MATING SURFACE OF THE HEADER PLATE (Gusset face)
module frame_assy() {
    // Header Plate (Connects to Steering Head)
    color(color_critical) translate([5, 0, 0]) rounded_box([10, 110, head_tube_length], r=2, center=true);

    // Gooseneck Riser (Tapered structural member with Gusseting)
    color(color_frame) for(s=[-1, 1]) {
        // Main structural riser
        hull() {
            translate([10, s * 45, 0]) sphere(d=55);
            translate([riser_length/2, s * (bed_internal_width/5), -riser_drop/2]) sphere(d=50);
            translate([riser_length, s * (bed_width/2 - 25), -riser_drop]) sphere(d=main_spar_size + 15);
        }
        // Gusset Plate (Reinforcement at the steering head)
        hull() {
            translate([10, s * 45, 0]) sphere(d=10);
            translate([10, s * 45, head_tube_length/2]) sphere(d=10);
            translate([100, s * 55, -50]) sphere(d=10);
        }
    }

    // Main Cargo Bed
    translate([riser_length, 0, -riser_drop]) {
        // Main Longitudinal Spars (with Mounting Holes)
        for(s=[-1, 1]) translate([bed_length/2, s * (bed_width/2 - main_spar_size/2), 0])
        color(color_frame) difference() {
            rect_tube(main_spar_size, main_spar_size, bed_length);
            // Cargo Box Mounting Holes (M8)
            for(x=[-bed_length/2 + 100 : 200 : bed_length/2 - 100])
                translate([x, 0, 0]) cylinder(d=8.5, h=main_spar_size + 1, center=true);
        }

        // Cross Members (with Electrical Mounting Holes)
        for(x=[100 : 400 : bed_length - 100]) translate([x, 0, 0])
        color(color_subframe) difference() {
            rect_tube(bed_width - 2*main_spar_size, 30, 40);
            // M6 holes for Battery/Controller mounting
            for(y=[-bed_width/4, bed_width/4])
                rotate([90, 0, 90]) cylinder(d=6.5, h=50, center=true);
        }

        // Cable Guides
        for(x=[200 : 300 : bed_length]) translate([x, -bed_width/2 - 12, -15]) cable_guide();

        // Rear Triangle Taper
        for(s=[-1, 1]) {
            color(color_frame) hull() {
                translate([bed_length, s * (bed_width/2 - main_spar_size/2), 0])
                sphere(d=main_spar_size);
                translate([bed_length + rear_extension, s * (rear_dropout_spacing/2 + 6), dropout_z_offset + 30])
                sphere(d=25);
            }
        }

        // Rear Mast and Dropouts
        translate([bed_length + rear_extension, 0, 0]) {
            // Seat Post Tube
            translate([-350, 0, 300]) color(color_subframe) pipe(38, 31.8, 550);
            // Brace
            translate([-350, 0, 100]) color(color_frame) rotate([0, 90, 0]) pipe(45, 40, 250);

            // Heavy Duty Dropouts
            for(s=[-1, 1]) {
                translate([0, s*(rear_dropout_spacing/2 + 6), dropout_z_offset])
                color(color_fastener) difference() {
                    rounded_box([80, 12, 100], r=5, center=true);
                    // Axle Slot
                    rotate([90, 0, 0]) cylinder(d=14.2, h=30, center=true);
                    // Lightening holes
                    translate([25, 0, 30]) rotate([90, 0, 0]) cylinder(d=15, h=30, center=true);
                }
            }
        }

        // Bottom Bracket Shell
        translate([bed_length - 200, 0, 85]) rotate([90, 0, 0]) color(color_brass) pipe(42, 34, 68);
    }
}
