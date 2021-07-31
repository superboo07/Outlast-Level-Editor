Class SHGame extends OLGame;

var Class<SHOptions> DefaultOptionsClass;
var SHOptions SHOptions;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal) { return Default.class; }

event InitGame( string Options, out string ErrorMessage )
{
	if (SHOptions == None)
	{
		SHOptions = Spawn(class'SpeedrunHelper.SHOptions');
	}
	super.InitGame(Options, ErrorMessage);
}

event PostBeginPlay()
{
	local Controller C;
	
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if ( SHHud(SHPlayerController(C).Hud) != None )
		{
			SHHud(SHPlayerController(C).Hud).CachedOptions=SHOptions;
		}
	}
}

DefaultProperties
{
	PlayerControllerClass=Class'SpeedrunHelper.SHPlayerController'
	HUDType=class'SpeedrunHelper.SHHud'
	DefaultPawnClass=class'SpeedrunHelper.SHHero'
	DefaultOptionsClass=class'SpeedrunHelper.SHOptions'
}