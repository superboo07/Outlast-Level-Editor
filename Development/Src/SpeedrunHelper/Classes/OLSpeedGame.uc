Class OLSpeedGame extends OLGame;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return Default.class;
}

DefaultProperties
{
    PlayerControllerClass=Class'OLSpeedController'
    HUDType=class'SpeedrunHelper.OLSpeedHud'
}