include <master_dims.scad>
include <parts.scad>

// MAIN FRAME ASSEMBLY
// Origin = MATING SURFACE OF THE HEADER PLATE (Gusset face)
module frame_assy() {
    color(color_frame) translate([5, 0, 0]) cube([10, 100, head_tube_length - 20], center=true);
    color(color_frame) for(s=[-1, 1]) {
        hull() {
            translate([10, s * 40, 0]) sphere(d=50);
            translate([riser_length/2, s * (bed_internal_width/6), -riser_drop/2]) sphere(d=45);
            translate([riser_length, s * (bed_width/2 - 20), -riser_drop]) sphere(d=main_spar_size + 10);
        }
    }
    translate([riser_length, 0, -riser_drop]) {
        translate([bed_length/2, 0, 0]) {
            for(s=[-1, 1]) translate([0, s * (bed_width/2 - main_spar_size/2), 0]) color(color_frame) rect_tube(main_spar_size, main_spar_size, bed_length);
            for(x=[-bed_length/2 + 20 : 400 : bed_length/2 - 20]) translate([x, 0, 0]) color(color_moving) rect_tube(bed_width - 2*main_spar_size, 20, 40);
            for(x=[-bed_length/2 + 100 : 300 : bed_length/2]) translate([x, -bed_width/2 - 10, -10]) cable_guide();
        }
        rear_extension = 150;
        dropout_z_offset = -50;
        for(s=[-1, 1]) {
            color(color_frame) hull() {
                translate([bed_length, s * (bed_width/2 - main_spar_size/2), 0]) cube([main_spar_size, main_spar_size, main_spar_size], center=true);
                translate([bed_length + rear_extension, s * (135/2 + 5), dropout_z_offset + 30]) cube([20, 10, 20], center=true);
            }
        }
        translate([bed_length + rear_extension, 0, 0]) {
            translate([-400, 0, 350]) color(color_subframe) pipe(35, 30, 500);
            translate([-400, 0, 100]) color(color_frame) rotate([0, 90, 0]) pipe(40, 35, 200);
            for(s=[-1, 1]) {
                translate([0, s*(135/2 + 5), dropout_z_offset]) color(color_fastener) difference() {
                    cube([60, 12, 80], center=true);
                    rotate([90, 0, 0]) cylinder(d=12, h=30, center=true);
                }
            }
        }
        translate([bed_length - 150, 0, 85]) rotate([90, 0, 0]) color(color_fastener) pipe(40, 34, 68);
    }
}
