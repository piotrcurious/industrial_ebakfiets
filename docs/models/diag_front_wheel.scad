include <master_dims.scad>
include <parts.scad>
include <front_wheel_assy.scad>

// Cross section to see the interface
difference() {
    front_wheel_assy();
    translate([0, 500, 0]) cube([1000, 1000, 1000], center=true);
}
