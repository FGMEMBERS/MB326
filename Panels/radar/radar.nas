# =======================
# Multiplayer Quirks
# =======================
MPjoin = func(n) {
   print(n.getValue(), " added");
   setprop("instrumentation/radar",n.getValue(),"radar/y-shift",0);
   setprop("instrumentation/radar",n.getValue(),"radar/x-shift",0);
   setprop("instrumentation/radar",n.getValue(),"radar/rotation",0);
   setprop("instrumentation/radar",n.getValue(),"radar/in-range",0);
   setprop("instrumentation/radar",n.getValue(),"radar/h-offset",180);
   setprop("instrumentation/radar",n.getValue(),"radar/range-nm", 0);
   setprop("instrumentation/radar",n.getValue(),"radar/ht-diff-ft",0);
   setprop("instrumentation/radar",n.getValue(),"joined",1);
   setprop("instrumentation/radar",n.getValue(),"callsign","noname");
}
MPleave= func(n) {
   print(n.getValue(), " removed");
   setprop("instrumentation/radar",n.getValue(),"radar/in-range",0);
   setprop("instrumentation/radar",n.getValue(),"joined",0);
}


#
# Need to copy the properties so that we never try to access a non-existent property in XML.
#
MPradarProperties = func 
{
	targetList= props.globals.getNode("ai/models/").getChildren("multiplayer");
	foreach (d; props.globals.getNode("ai/models/").getChildren("aircraft")) 
	{
		append(targetList,d);
	}
	
	foreach (m; targetList) 
	{
		var string = "instrumentation/radar/ai/models/"~m.getName()~"["~m.getIndex()~"]/";
		if (getprop(string,"joined")==1 or m.getName()=="aircraft") 
		{
			setprop(string,"callsign",m.getNode("callsign").getValue());
			
			factor = getprop("instrumentation/radar/range-factor");
			setprop(string,"radar/h-offset",m.getNode("radar/h-offset").getValue());
			setprop(string,"radar/range-nm",m.getNode("radar/range-nm").getValue());
			setprop(string,"radar/elevation-deg",m.getNode("radar/elevation-deg").getValue());
			setprop(string,"radar/y-shift",m.getNode("radar/y-shift").getValue() * factor);
			setprop(string,"radar/x-shift",m.getNode("radar/x-shift").getValue() * factor);
			setprop(string,"radar/rotation",m.getNode("radar/rotation").getValue());
			setprop(string,"radar/ht-diff-ft",m.getNode("radar/ht-diff-ft").getValue());
			setprop(string,"radar/bearing-deg",m.getNode("radar/bearing-deg").getValue());
					
			setprop(string,"radar/in-range",m.getNode("radar/in-range").getValue());
		} 
   	}

   settimer(MPradarProperties,0.5);
}


setprop("instrumentation/radar/range-factor",1.0);
setprop("instrumentation/radar/range", 40);
setprop("instrumentation/radar/selected", 2);

setlistener("ai/models/model-added", MPjoin);
setlistener("ai/models/model-removed", MPleave);
settimer(MPradarProperties,1.0);
## settimer(boreSightLock, 1.0);

