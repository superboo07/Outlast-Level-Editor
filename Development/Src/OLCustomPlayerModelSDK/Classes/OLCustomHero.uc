class OLCustomHero extends OLHero
;

Var OLPlayerController NewController;

//Run every time the pawn is posssed by a controller. 
function PossessedBy(Controller C, bool bVehicleTransition)
{
    //Run the function from the parent of this pawn, which would be OLHero.
        super.PossessedBy(C, bVehicleTransition);
        NewController=OLPlayerController(C);

    //Run the UseCustomModel Event.
        UseCustomModel();
}

Event UseCustomModel()
{
    //Define local variables

        local OLCustomGame Gameinfo; //Game info
        local OLPlayerModel PlayerModel;

        //Local Mesh Variables
            local SkeletalMesh Body;
            local StaticMesh Head;

        //Local Footprint Variables
            local MaterialInstanceConstant Left_Footprint_1;
            local MaterialInstanceConstant Left_Footprint_2;
            local MaterialInstanceConstant Right_Footprint_1;
            local MaterialInstanceConstant Right_Footprint_2;

        //Offset used for the Head Mesh
            local vector Head_Offset;

    /* Set the gameinfo variable to the currently used Gameinfo object, 
    and make sure it is OLGameTemplate, or a child of OLGameTemplate */
    Gameinfo = OLCustomGame(Worldinfo.Game);
    PlayerModel = OLPlayerModel(DynamicLoadObject(Gameinfo.PlayerModel, class'OLPlayerModel'));

    //Set Local Variables using the variables from the GameInfo.

        //Define Mesh parts
            Body = PlayerModel.HeroBody;
            Head = PlayerModel.Hero_Head;

        //Define the offset applied to the head mesh
            Head_Offset = PlayerModel.Head_Offset;

        //Set the Local Footprint variables 
            Left_Footprint_1=PlayerModel.Left_Footprint_1;
            Left_Footprint_2=PlayerModel.Left_Footprint_2;
            Right_Footprint_1=PlayerModel.Right_Footprint_1;
            Right_Footprint_2=PlayerModel.Right_Footprint_2;

    //Apply Custom Model Changes

        //Skeletal Meshes
            Mesh.SetSkeletalMesh(Body);
            ShadowProxy.SetSkeletalMesh(Body);

        //StaticMeshes
            HeadMesh.SetStaticMesh(Head);

        //Apply Head Offset
            if (Playermodel.Should_Offset_Head==True)
            {
                HeadMesh.SetTranslation(Head_Offset);
            }

    //Apply Footprint Changes
        if (PlayerModel.Should_Override_FootPrints==true)
        {
            //Override Footprints for MainGame
                FootstepDecalMatL1=Left_Footprint_1;
                FootstepDecalMatL2=Left_Footprint_2;
                FootstepDecalMatR1=Right_Footprint_1;
                FootstepDecalMatR2=Right_Footprint_2;

            //Override Footprints for WhistleBlower
                FootstepBarefeetDecalMatL1=Left_Footprint_1;
                FootstepBarefeetDecalMatL2=Left_Footprint_2;
                FootstepBarefeetDecalMatR1=Right_Footprint_1;
                FootstepBarefeetDecalMatR2=Right_Footprint_2;
        }

    //Apply Gameplay Variable Changes

        if (PlayerModel.Should_Change_Gameplay_Variables==True)
        {
            //Speed Overrides
                NormalWalkSpeed=PlayerModel.Walk_Speed;
                NormalRunSpeed=PlayerModel.Run_Speed;
                CrouchedSpeed=PlayerModel.CrouchedSpeed;
                ElectrifiedSpeed=PlayerModel.ElectrifiedSpeed;
                WaterWalkSpeed=PlayerModel.WaterWalkSpeed;
                WaterRunSpeed=PlayerModel.WaterRunSpeed;
                LimpingWalkSpeed=PlayerModel.LimpingWalkSpeed;
                HobblingWalkSpeed=PlayerModel.HobblingWalkSpeed;
                HobblingRunSpeed=PlayerModel.HobblingRunSpeed;

            //FOV Overrides
                DefaultFOV=PlayerModel.DefaultFOV;
                RunningFOV=PlayerModel.RunningFOV;
                CamcorderMinFOV=PlayerModel.CamcorderMinFOV;
                CamcorderNVMaxFOV=PlayerModel.CamcorderNVMaxFOV;
                CamcorderMaxFOV=PlayerModel.CamcorderMaxFOV;
        }
    //Used to check if variables for the pawn have been overridden. 
    if (
        NormalWalkSpeed!=200.0 
        || 
        NormalRunSpeed!=450.0 
        || 
        CrouchedSpeed!=75.0 
        || 
        ElectrifiedSpeed!=100 
        || 
        WaterWalkSpeed!=100.0 
        || 
        WaterRunSpeed!=200.0 
        || 
        LimpingWalkSpeed!=87.2430 
        ||
        HobblingWalkSpeed!=140.0 
        || 
        HobblingRunSpeed!=250.0 
        || 
        DefaultFOV!=90.0 
        || 
        RunningFOV!=100.0
        ||
        CamcorderMinFOV!=15.0
        ||
        CamcorderNVMaxFOV!=83.0
        ||
        CamcorderMaxFOV!=83.0
        )
    {
        GameInfo.Modify_Extra = True; //Set Value to True so the HUD will display the watermark
    }
}

defaultproperties
{
    //Define Light Enviornment, this makes static lights still light the character. 
    begin object name=MyLightEnvironment
        bEnabled=True
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
        bForceNonCompositeDynamicLights=true
    End Object
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    //Define Main Body, this is what the player see's when looking down.
    begin object name=WPawnSkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
        LightEnvironment=MyLightEnvironment
    End Object

    //This is what is used for the shadow.
    begin object name=ShadowProxyComponent
        SkeletalMesh=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object

    // This is the head mesh seen in the shadow. 
    begin object name=HeadMeshComp
        StaticMesh=StaticMesh'02_Player.Pawn.Miles_head'
        ShadowParent=SkeletalMeshComponent'ShadowProxyComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object
}