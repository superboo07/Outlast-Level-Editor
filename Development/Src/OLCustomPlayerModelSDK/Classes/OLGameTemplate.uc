class OLGameTemplate extends OLGame
    hidecategories(Navigation);

var() SkeletalMesh HeroBody;
var() StaticMesh Hero_Head;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return Default.class;
}

defaultproperties
{
    //Use Pawn and Controller built into SDK
    PlayerControllerClass=class'OLCustomPlayerModelSDK.OLCustomPlayerController'
    DefaultPawnClass=class'OLCustomPlayerModelSDK.OLCustomHero'

    //Define Mesh
    HeroBody=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
    Hero_Head=StaticMesh'02_Player.Pawn.Miles_head'
}