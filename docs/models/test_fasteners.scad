include <master_dims.scad>
use <parts.scad>
rim_fastener_pattern();
// Reference axes
color("red") cube([100, 1, 1]); // X
color("green") cube([1, 100, 1]); // Y
color("blue") cube([1, 1, 100]); // Z
