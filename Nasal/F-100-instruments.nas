var instruments = func {

# ACCELEROMETER

var z_accel = getprop("/accelerations/pilot/z-accel-fps_sec");
#var G = z_accel / -32.174;
var G = getprop("/accelerations/pilot-gdamped");
setprop("/instrumentation/accelerometer/G", G);
var G_min = getprop("/instrumentation/accelerometer/G-min");
var G_max = getprop("/instrumentation/accelerometer/G-max");
	if (G < 1 and G < G_min){
		setprop("/instrumentation/accelerometer/G-min", G);
		} else {
		if (G > G_max){
			setprop("/instrumentation/accelerometer/G-max", G);
			}
		}
	var reset = getprop("/instrumentation/accelerometer/reset");
	if (reset == 1) {
		setprop("/instrumentation/accelerometer/G-min", 1.0);
		setprop("/instrumentation/accelerometer/G-max", 1.0);
		setprop("/instrumentation/accelerometer/reset", 0);
		}

# ALTIMETER UPDATE FOR 18000-FT TRANSITION

var valid = getprop("/environment/metar/valid");
var metar = getprop("/environment/metar/pressure-inhg");
var alt = getprop("/position/altitude-ft");
var press_alt = getprop("/instrumentation/altimeter/pressure-alt-ft");
var set = getprop("/instrumentation/altimeter/setting-inhg");
if (valid == 1 and alt <= 18000) {
		setprop("/instrumentation/altimeter/setting-inhg", metar);
		}
if (valid == 1 and alt > 18000) {
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/instrumentation/altimeter/indicated-altitude-ft", press_alt);
		}
if (valid == 0) {
		setprop("/environment/pressure-sea-level-inhg", set);
		}

# APPROACH SPEED

var total = getprop("/fdm/jsbsim/propulsion/total-fuel-lbs");
var speed = (155+(3*(total/1000)));
setprop("/velocities/approach-speed", speed);

#AUTO-ILS DISENGAGE

var agl = getprop("/position/altitude-agl-ft");
if (agl <= 100) {
		setprop("/autopilot/locks/altitude", "");
		setprop("/autopilot/locks/heading", "");
		setprop("/autopilot/locks/speed", "");
		}

# CDI POINTER

heading = getprop("/orientation/heading-magnetic-deg");
course = getprop("/instrumentation/cdi/course-set");
	if (heading > 360){
		heading = heading - 360;
	}
pointer = (heading - course);
	if (pointer > 360){
		pointer = pointer - 360;
	}
	if (pointer < 0){
		pointer = 360 + pointer;
	}		
	if (pointer > 45 and pointer < 90){
		pointer = 45;
	}
	elsif (pointer < 135 and pointer >= 90){
		pointer = 135;
	}
	elsif (pointer > 225 and pointer <= 270){
		pointer = 225;
	}
	elsif (pointer < 315 and pointer > 270){
		pointer = 315;
	}
setprop("/instrumentation/cdi/pointer", pointer);

# CLOCK, OFFSET TO LOCAL TIME

var offset = getprop("/sim[0]/time/local-offset");
setprop("/instrumentation/clock/offset-sec", offset);

# EGT CONVERSION, FAHRENHEIT TO CENTIGRADE

var F = getprop("/engines/engine[0]/egt-degf");
var C = (F - 32) * 5/9;
setprop("/engines/engine[0]/egt-degc", C);

# VERTICAL SPEED IN FEET PER MINUTE

var v_fps = getprop("/velocities/vertical-speed-fps");
var v_fpm = v_fps * 60;
setprop("/velocities/vertical-speed-fpm", v_fpm);

settimer(instruments, 0.1);
}
setlistener("sim/signals/fdm-initialized", instruments);

