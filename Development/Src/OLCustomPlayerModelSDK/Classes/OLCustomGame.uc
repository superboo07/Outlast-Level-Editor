class OLCustomGame extends OLGame
    Config(PlayerModel);

var config string PlayerModel;

//DO NOT OVERWRITE

var Bool Modify_Extra; //If you set this to true, the watermark for gameplay variables will always be shown. 

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return Default.class;
}

defaultproperties
{
    //Class Overrides
    PlayerControllerClass=class'OLCustomPlayerModelSDK.OLCustomPlayerController'
    DefaultPawnClass=class'OLCustomPlayerModelSDK.OLCustomHero'
    HUDType=class'OLCustomPlayerModelSDK.OLCustomHud'
}