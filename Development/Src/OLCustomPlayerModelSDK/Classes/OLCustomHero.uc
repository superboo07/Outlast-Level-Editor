class OLCustomHero extends OLHero
    hidecategories(Navigation);

//Run every time the pawn is posssed by a controller. 
function PossessedBy(Controller C, bool bVehicleTransition)
{
    //Run the function from the parent of this pawn, which would be OLHero.
    super.PossessedBy(C, bVehicleTransition);

    //Run the UseCustomModel Event.
    UseCustomModel();
}

Event UseCustomModel()
{
    //Define local variables to make the script cleaner.
    local SkeletalMesh Body;
    local StaticMesh Head;
    local OLGameTemplate Gameinfo;

    /* Set the gameinfo variable to the currently used Gameinfo object, 
    and make sure it is OLGameTemplate, or a child of OLGameTemplate */
    Gameinfo = OLGameTemplate(Worldinfo.Game);

    //Define Mesh parts using the meshes defined in the GameInfo.
    Body =  Gameinfo.HeroBody;
    Head = Gameinfo.Hero_Head;

    //Set each mesh of the pawn to their corresponding mesh. 
    Mesh.SetSkeletalMesh(Body);
    ShadowProxy.SetSkeletalMesh(Body);
    HeadMesh.SetStaticMesh(Head);
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