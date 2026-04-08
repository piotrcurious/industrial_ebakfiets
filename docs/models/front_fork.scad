include <parts.scad>

module front_fork() {
    // Steerer
    translate([0, 0, 150]) cylinder(d=15, h=300, center=true, $fn=64);

    // Crown Plate
    translate([0, 0, 0]) cube([40, 250, 10], center=true);

    // Legs (Inner width 200)
    translate([0, 110, -175]) rect_tube(20, 40, 350, 3);
    translate([0, -110, -175]) rect_tube(20, 40, 350, 3);

    // Steering Arm
    color("red")
    translate([50, 0, -5]) cube([100, 20, 10], center=true);
}

front_fork();
