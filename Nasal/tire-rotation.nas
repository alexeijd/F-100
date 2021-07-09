rotate = func {
var nose = getprop("/fdm/jsbsim/gear/unit[0]/wheel-speed-fps");
var left = getprop("/fdm/jsbsim/gear/unit[1]/wheel-speed-fps");
var right = getprop("/fdm/jsbsim/gear/unit[2]/wheel-speed-fps"); 
var nose_rpm = (nose * .6 * 25.192562);
setprop("/fdm/jsbsim/gear/unit[0]/RPM", nose_rpm);
var left_rpm = (left * .6 * 13.460785);
setprop("/fdm/jsbsim/gear/unit[1]/RPM", left_rpm);
var right_rpm = (right * .6 * 13.460785);
setprop("/fdm/jsbsim/gear/unit[2]/RPM", right_rpm);
settimer(rotate, 0.1);
}
setlistener("sim/signals/fdm-initialized", rotate);