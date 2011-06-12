// Copyright 2010 David Watson <david@neonquill.com>
// This work is licensed under the
//  Creative Commons Attribution-ShareAlike 3.0 Unported License. 
//  http://creativecommons.org/licenses/by-sa/3.0/

$fs = 0.2;

in_to_mm = 25.4;

// Design parameters.
dowel_radius = (0.25 * in_to_mm) / 2.0;
screw_radius = ((0.164 + 0.001) * in_to_mm) / 2.0;
wall_thickness = 2.0;

// Calculated parameters.
dowel_total_radius = dowel_radius + wall_thickness;
screw_total_radius = screw_radius + wall_thickness;

dowel_vert_offset = screw_total_radius + dowel_radius;


module solid() {

	// Screw for 8-32
	rotate(a=[90, 0, 0]) {
		translate([0, 0, -dowel_total_radius]) {
			cylinder(h=dowel_total_radius*2, r=screw_total_radius);
		}
	}
	// 1/4" dowel
	translate([0, 0, dowel_vert_offset]) {
		rotate(a=[0, 90, 0]) {
			translate([0, 0, -screw_total_radius]) {
				cylinder(h=screw_total_radius * 2, r=dowel_total_radius);
			}
		}
	}

	translate([-1, -dowel_total_radius, screw_radius]) {
		cube(size=[2, dowel_total_radius*2, dowel_total_radius]);
	}

	translate([-screw_total_radius, -1, 0]) {
		cube(size=[screw_total_radius * 2, 2, screw_total_radius]);
	}
}

module hinge() {
	difference() {
		solid();

		// Screw for 8-32.
		rotate(a=[90, 0, 0]) {
			translate([0, 0, -9]) {
				cylinder(h=9*2, r=screw_radius);
			}
		}

		// 1/4" dowel
		translate([0, 0, dowel_vert_offset]) {
			rotate(a=[0, 90, 0]) {
				translate([0, 0, -10]) {
					cylinder(h=20, r=dowel_radius);
				}
			}
		}
	}
}

module rev_dot() {
	translate([screw_total_radius, 0, 1]) {
		sphere(r=0.3);
	}
}

union() {
	hinge();
	rev_dot();
}

