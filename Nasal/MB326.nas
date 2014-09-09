#
# MB326.nas
# 04/06/2009
# Charles INGELS, charles@maisonblv.net
# Script NaSAL principal pour le MB326.
#
#

#
setprop("weight[0]/selected", "false");
setprop("weight[1]/selected", "false");


#
# Création des feux de navigation et stroboscopiques.
#
var strobe = aircraft.light.new("/sim/model/lights/strobe1", [0.05, 0.05, 0.05, 0.7]);
strobe.interval = 0;
strobe.switch(0);

var strobe = aircraft.light.new("/sim/model/lights/strobe2", [0.05, 0.05, 0.05, 0.7]);
strobe.interval = 0;
strobe.switch(0);

var strobe = aircraft.light.new("/sim/model/lights/redlight", [0.3, 0.6]);
strobe.interval = 0;
strobe.switch(0);

var strobe = aircraft.light.new("/sim/model/lights/greenlight", [0.3, 0.6]);
strobe.interval = 0;
strobe.switch(0);

#
# Facteur d'illumination des instruments de bord (bien pratique lors des vols de nuit).
#
setprop("/sim/model/material/instruments/factor", 2);

setprop("/controls/gear/gear-position", 1);

#
# Gestion des interrupteurs contrôlant les feux de navigation
# et l'éclairage stroboscopique.
#
setprop("/controls/switches/nav_lights_enable", 0);
setprop("/controls/switches/strobe_lights_enable", 0);

var ActivateNavLightsSwitch = func 
{
	if(getprop("/sim/model/lights/redlight/enabled"))
		setprop("/controls/switches/nav_lights_enable", 1);
	else
		setprop("/controls/switches/nav_lights_enable", 0);
}

var ActivateStroboLightsSwitch = func 
{
    if(getprop("/sim/model/lights/strobe1/enabled"))
    {
	# print("Strobe light ON");
	setprop("/controls/switches/strobe_lights_enable", 1);
    }
    else
    {
	# print("Strobe light OFF");
	setprop("/controls/switches/strobe_lights_enable", 0);
    }
}


var ManageGearHandle = func
{
    if(getprop("/controls/gear/gear-down"))
    {
	print("Gear position 1");
	setprop("/controls/gear/gear-position", 1);
    }
    else
    {
	print("Gear position 0");
	setprop("/controls/gear/gear-position", 0);
    }
}

#
# Connexion des "listeners" pour l'activation et la désactivation des lumières.
#
setlistener("/sim/model/lights/redlight/enabled", ActivateNavLightsSwitch);
setlistener("/sim/model/lights/strobe1/enabled", ActivateStroboLightsSwitch);
setlistener("/controls/gear/gear-down", ManageGearHandle);

# Appel de fonctions lors de l'initialisation du FDM.
## setlistener("/sim/signals/fdm-initialized", <votre fonction>);

