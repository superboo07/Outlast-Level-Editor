/*This class is meant to be used for defining custom player models. In order to use it you must make an archetype in editor. 
Then in the DefaultPlayerModel.ini file for your player model, paste the following lines.

[OLCustomPlayerModelSDK.OLCustomGame]
PlayerModel=<PathToArchetype>

Obviously replacing <PathToArchetype> to the path of your archetype.*/

class OLPlayerModel extends object;

//Settings
var(Settings) Bool Should_Offset_Head;
var(Settings) bool Should_Override_FootPrints;
var(Settings) Bool Should_Change_Gameplay_Variables;
var(Settings) bool Block_Model_Changes;

//Mesh
var(Mesh) SkeletalMesh HeroBody;
var(Mesh) StaticMesh Hero_Head;
var(Mesh) vector Head_Offset; //Vector For offsetting the head, I recommend leaving this at x=2, but if need be you can change it. 

//Variables used for changing footprints, I'm not sure how to use the foot print materials, but here are variables for replacing them anyway.
var(Footprints) MaterialInstanceConstant Left_Footprint_1;
var(Footprints) MaterialInstanceConstant Left_Footprint_2;
var(Footprints) MaterialInstanceConstant Right_Footprint_1;
var(Footprints) MaterialInstanceConstant Right_Footprint_2;

//Gameplay Variables
var(Gameplay) float Walk_Speed;
var(Gameplay) float Run_Speed;
var(Gameplay) float CrouchedSpeed;
var(Gameplay) float ElectrifiedSpeed;
var(Gameplay) float WaterWalkSpeed;
var(Gameplay) float WaterRunSpeed;
var(Gameplay) float LimpingWalkSpeed;
var(Gameplay) float HobblingWalkSpeed;
var(Gameplay) float HobblingRunSpeed;
var(Gameplay) float DefaultFOV;
var(Gameplay) float RunningFOV;
var(Gameplay) float CamcorderMinFOV;
var(Gameplay) float CamcorderMaxFOV;
var(Gameplay) float CamcorderNVMaxFOV;

DefaultProperties
{
    HeroBody=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
    Hero_Head=StaticMesh'02_Player.Pawn.Miles_head'

    Should_Offset_Head=True

    Head_Offset=(x=-2,y=0,z=0) //Default Value for the Head Offset

    Should_Override_FootPrints=False
    Left_Footprint_1=MaterialInstanceConstant'Decals.Blood.FootPrint_L1_mat'
    Left_Footprint_2=MaterialInstanceConstant'Decals.Blood.FootPrint_L2_mat'
    Right_Footprint_1=MaterialInstanceConstant'Decals.Blood.FootPrint_R1_mat'
    Right_Footprint_2=MaterialInstanceConstant'Decals.Blood.FootPrint_R2_mat'

    Should_Change_Gameplay_Variables=False

    //Gameplay Values, changing these will trigger the watermark.
    Walk_Speed=200
    Run_Speed=450
    CrouchedSpeed=75
    ElectrifiedSpeed=100
    WaterWalkSpeed=100.0
    WaterRunSpeed=200.0
    LimpingWalkSpeed=87.2430
    HobblingWalkSpeed=140.0
    HobblingRunSpeed=250.0
    DefaultFOV=90.0
    RunningFOV=100.0
    CamcorderMinFOV=15.0
    CamcorderNVMaxFOV=83.0
    CamcorderMaxFOV=83.0
    Block_Model_Changes=true
}