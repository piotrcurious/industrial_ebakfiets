include <parts.scad>

module front_fork() {
    // Coordinate system: X forward, Z up

    // Steerer (15mm)
    color("gray")
    translate([0, 0, 150]) cylinder(d=15, h=300, center=true);

    // Crown Plate (10mm thick, 250mm wide)
    color("black")
    translate([0, 0, 0]) cube([40, 250, 10], center=true);

    // Fork Legs (40x20mm) - 200mm inner width
    color("gray") {
        translate([0, 110, -175]) rect_tube(20, 40, 350);
        translate([0, -110, -175]) rect_tube(20, 40, 350);
    }

    // Dropouts
    color("silver") {
        translate([0, 110, -350]) cube([40, 8, 50], center=true);
        translate([0, -110, -350]) cube([40, 8, 50], center=true);
    }
}

front_fork();
