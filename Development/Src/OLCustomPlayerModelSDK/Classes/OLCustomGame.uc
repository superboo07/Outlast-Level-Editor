class OLCustomGame extends OLGame
    Config(PlayerModel);

/*
//This variable is used to define what the body mesh will look like. 
var() SkeletalMesh HeroBody;

//Used to define the mesh used for the head.
var() StaticMesh Hero_Head;

//Used to define if the head should be offset from the body. 
var() Bool Offset_Head;

//Used to define the offset from the head to the body mesh
var() vector Head_Offset;

var() MaterialInstanceConstant Left_Footprint_1;
var() MaterialInstanceConstant Left_Footprint_2;
var() MaterialInstanceConstant Right_Footprint_1;
var() MaterialInstanceConstant Right_Footprint_2;
 
var() float Walk_Speed;
var() float Run_Speed;
var() float CrouchedSpeed;
var() float ElectrifiedSpeed;
var() float WaterWalkSpeed;
var() float WaterRunSpeed;
var() float LimpingWalkSpeed;
var() float HobblingWalkSpeed;
var() float HobblingRunSpeed;

var() bool Block_Model_Changes;*/

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