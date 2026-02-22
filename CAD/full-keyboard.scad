/* [Rendering options] */
// Show placeholder PCB in OpenSCAD preview
show_pcb = false;
// Lid mounting method
lid_model = "cap"; // [cap, inner-fit]
// Conditional rendering
render = "case"; // [all, case, lid]


/* [Dimensions] */
// Height of the PCB mounting stand-offs between the bottom of the case and the PCB
standoff_height = 5;
// PCB thickness
pcb_thickness = 1.6;
// Bottom layer thickness
floor_height = 1.2;
// Case wall thickness
wall_thickness = 1.2;
// Space between the top of the PCB and the top of the case
headroom = 3.4999999999999996;

/* [M2.5 screws] */
// Outer diameter for the insert
insert_M2_5_diameter = 3.27;
// Depth of the insert
insert_M2_5_depth = 3.75;

/* [Hidden] */
$fa=$preview ? 10 : 4;
$fs=0.2;
inner_height = floor_height + standoff_height + pcb_thickness + headroom;

module wall (thickness, height) {
    linear_extrude(height, convexity=10) {
        difference() {
            offset(r=thickness)
                children();
            children();
        }
    }
}

module bottom(thickness, height) {
    linear_extrude(height, convexity=3) {
        offset(r=thickness)
            children();
    }
}

module lid(thickness, height, edge) {
    linear_extrude(height, convexity=10) {
        offset(r=thickness)
            children();
    }
    translate([0,0,-edge])
    difference() {
        linear_extrude(edge, convexity=10) {
                offset(r=-0.2)
                children();
        }
        translate([0,0, -0.5])
         linear_extrude(edge+1, convexity=10) {
                offset(r=-1.2)
                children();
        }
    }
}


module box(wall_thick, bottom_layers, height) {
    if (render == "all" || render == "case") {
        translate([0,0, bottom_layers])
            wall(wall_thick, height) children();
        bottom(wall_thick, bottom_layers) children();
    }
    
    if (render == "all" || render == "lid") {
        translate([0, 0, height+bottom_layers+0.1])
        lid(wall_thick, bottom_layers, lid_model == "inner-fit" ? headroom-2.5: bottom_layers) 
            children();
    }
}

module mount(drill, space, height) {
    translate([0,0,height/2])
        difference() {
            cylinder(h=height, r=(space/2), center=true);
            cylinder(h=(height*2), r=(drill/2), center=true);
            
            translate([0, 0, height/2+0.01])
                children();
        }
        
}

module connector(min_x, min_y, max_x, max_y, height) {
    size_x = max_x - min_x;
    size_y = max_y - min_y;
    translate([(min_x + max_x)/2, (min_y + max_y)/2, height/2])
        cube([size_x, size_y, height], center=true);
}

module Cutout_TypeC_substract() {
    width = 10;
    length = 10;
    height = 3.5;
    translate([-length/2, 0, height/2])
    rotate([0,90,0])
        union() {
            translate([0, -(width/2 - height/2), 0])
                cylinder(length, height/2, height/2);
            translate([0, (width/2 - height/2), 0])
                cylinder(length, height/2, height/2);
            translate([0, 0, length/2])
                cube([height, width-height, length], center=true);
        }
}

module pcb() {
    thickness = 1.6;

    color("#009900")
    difference() {
        linear_extrude(thickness) {
            polygon(points = [[34.9,20.76], [468.9,20.76], [468.9,187.6], [34.9,187.6]]);
        }
    translate([466, 23.8, -1])
        cylinder(thickness+2, 1.1000000000000014, 1.1000000000000014);
    translate([38.4, 23.8, -1])
        cylinder(thickness+2, 1.1000000000000014, 1.1000000000000014);
    translate([466, 184.6, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    translate([238.6, 29, -1])
        cylinder(thickness+2, 1.1000000000000014, 1.1000000000000014);
    translate([241, 184.6, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    translate([39, 184.4, -1])
        cylinder(thickness+2, 1.0999999999999943, 1.0999999999999943);
    }
}

module case_outline() {
    polygon(points = [[33.4,19], [471,19], [471,189.4], [33.4,189.4]]);
}

module Insert_M2_5() {
    translate([0, 0, -insert_M2_5_depth])
        cylinder(insert_M2_5_depth, insert_M2_5_diameter/2, insert_M2_5_diameter/2);
    translate([0, 0, -0.3])
        cylinder(0.3, insert_M2_5_diameter/2, insert_M2_5_diameter/2+0.3);
}

rotate([render == "lid" ? 180 : 0, 0, 0])
scale([1, -1, 1])
translate([-252.2, -104.2, 0]) {
    pcb_top = floor_height + standoff_height + pcb_thickness;

    difference() {
        box(wall_thickness, floor_height, inner_height) {
            case_outline();
        }

    // Substract: Unknown
    translate([471, 43.4, pcb_top])
        Cutout_TypeC_substract();

    }

    if (show_pcb && $preview) {
        translate([0, 0, floor_height + standoff_height])
            pcb();
    }

    if (render == "all" || render == "case") {
        // REF** [('M2.5', 2.5)]
        translate([466, 23.8, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([38.4, 23.8, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([466, 184.6, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([238.6, 29, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([241, 184.6, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([39, 184.4, floor_height])
        mount(2.2, 4.9, standoff_height)
            Insert_M2_5();
    }
}
