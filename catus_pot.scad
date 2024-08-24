$fn=300;
circ_d      = 150; // 150
imprint_d   = 10;  // 10
imprint_h   = 5;   // 5
imprint_vs  = 6;   // 6
pot_h       = 100; // 100


color("#AAF0C1",0.75)
difference(){
    //base shape
    linear_extrude(pot_h){
        hull(){
            circle(d=circ_d);
            translate([circ_d,0,0])circle(d=circ_d);
        };
    };
    //imprints on arc
    for(flip=[0:circ_d:circ_d])
    for(z_i=[-pot_h:imprint_d*1.5:pot_h*2]){
        for(i=[-90:10:90]){
            if(i/2+z_i >= imprint_d/2
                && i/2+z_i <= pot_h-imprint_d*2){
                translate([flip,0,0])
                rotate([0,0,i+(flip > 0 ? 180:0)])
                translate([
                    -circ_d/2-imprint_h/2,
                    0,
                    imprint_d+i/2+z_i])
                rotate([0,90,0])
                    imprint();
        
            }
        }
    };
    //imprints on flat faces 
    arc_l = circ_d*sin(1/2)-0.05; //unfloding the cylinder
    for(flip=[0:circ_d:circ_d])translate([0,flip,0])
    for(i=[0:10:100]){     
        for(z_i=[-pot_h:imprint_d*1.5:pot_h*2]){
            if(i/2+z_i >= imprint_d/2
                && i/2+z_i <= pot_h-imprint_d*2){
                translate([
                    arc_l*i+imprint_d*1.2,
                    -circ_d/2-imprint_h/2,
                    imprint_d+z_i+i/2])
                rotate([0,90,90])
                    imprint();
            }
        }
    };
    //cut out inside
    translate([0,0,2.4])
    linear_extrude(pot_h){
        hull(){
            circle(d=circ_d-2.4*4);
            translate([circ_d,0,0])circle(d=circ_d-2.4*4);
        };
    }; 

};
module imprint(){
    cylinder(h=imprint_h, d=imprint_d, $fn=imprint_vs);
}


