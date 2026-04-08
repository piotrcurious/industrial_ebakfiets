include <parts.scad>

module front_fork() {
    // Steerer (Connects to steering head)
    translate([0, 0, 150]) cylinder(d=15, h=300, center=true, $fn=64);

    // Crown Plate (10mm thick, 250mm wide)
    color("darkslategray")
    translate([0, 0, 0]) cube([40, 250, 10], center=true);

    // Fork Legs (40x20x3mm)
    // Inner width 200mm -> Center to center 220mm
    color("gray") {
        translate([0, 110, -175]) rect_tube(20, 40, 350, 3);
        translate([0, -110, -175]) rect_tube(20, 40, 350, 3);
    }

    // Dropouts (8mm Plate)
    color("silver") {
        translate([0, 110, -350]) cube([40, 8, 50], center=true);
        translate([0, -110, -350]) cube([40, 8, 50], center=true);
    }

    // Steering Arm (100mm)
    color("red")
    translate([50, 0, 0]) cube([100, 20, 10], center=true);

    // Brake Mount (Post Mount Ref)
    color("brown")
    translate([0, 90, -250]) cube([10, 20, 60], center=true);
}

front_fork();
