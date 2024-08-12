/*
	******************************** R E S E T ******************************************
	While starting the clock once we power it, we require to do TWO reset or TWO set.
	
	This is bc, in the first reset/set :xxx_setValues are initialized (based on reset/set) but,
	For the CounterBCD gets set to 8'bz and the entire DigitalClock output goes to Hi-z.
	
	In the second reset, the earlier initilized value gets to the DigitalClock output and everything
	runs smoothy from there.
	***************************************************************************************
	
	******************************** S E T ******************************************	
	First set the value of xxx_setValues and then hit Set.
	This way set will not require two steps.
	Bc, we are initilizing xxx_setValues mannually.
*/
