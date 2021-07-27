Class OLSpeedGame extends OLGame;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal) { return Default.class; }

DefaultProperties
{
	PlayerControllerClass=Class'SpeedrunHelper.SHPlayerController'
	HUDType=class'SpeedrunHelper.SHHud'
	DefaultPawnClass=class'SpeedrunHelper.SHHero'
}