class OLGameTemplate extends OLGame
    hidecategories(Navigation);

var() SkeletalMesh HeroBody;
var() StaticMesh Hero_Head;
var() vector Head_Offset;
 
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return Default.class;
}

defaultproperties
{
    //Use Pawn and Controller built into the playermodelSDK. Don't override these unless you absoulutly have to. 
    PlayerControllerClass=class'OLCustomPlayerModelSDK.OLCustomPlayerController'
    DefaultPawnClass=class'OLCustomPlayerModelSDK.OLCustomHero'

    //These are the mesh defintions, override these in your child class with the meshes you want to use. 
    HeroBody=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
    Hero_Head=StaticMesh'02_Player.Pawn.Miles_head'
    Head_Offset=(x=-2,y=0,z=0)
}