include <master_dims.scad>
include <parts.scad>
include <front_wheel_assy.scad>

translate([0, 0, front_tire_od/2])
front_wheel_assy();
