class OLCustomHero extends OLHero
    hidecategories(Navigation);

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    UseCustomModel();
}

Event UseCustomModel()
{
    local SkeletalMesh Body;
    local StaticMesh Head;
    local OLGameTemplate Gameinfo;

    Gameinfo = OLGameTemplate(Worldinfo.Game);
    Body =  Gameinfo.HeroBody;
    Head = Gameinfo.Hero_Head;

    WorldInfo.Game.BroadcastHandler.Broadcast(self, "Enabling Custom Model");
    Mesh.SetSkeletalMesh(Body);
    ShadowProxy.SetSkeletalMesh(Body);
    HeadMesh.SetStaticMesh(Head);
}

defaultproperties
{

    begin object name=MyLightEnvironment
        bEnabled=TRUE
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
        bForceNonCompositeDynamicLights=true
    End Object
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    begin object name=WPawnSkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
        LightEnvironment=MyLightEnvironment
    End Object

    begin object name=ShadowProxyComponent
        SkeletalMesh=SkeletalMesh'02_Player.Pawn.Miles_beheaded'
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object

    begin object name=HeadMeshComp
        StaticMesh=StaticMesh'02_Player.Pawn.Miles_head'
        ShadowParent=SkeletalMeshComponent'ShadowProxyComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'MyLightEnvironment'
    End Object

}