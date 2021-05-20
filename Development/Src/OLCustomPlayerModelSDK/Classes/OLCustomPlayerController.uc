class OLCustomPlayerController extends OLPlayerController
    hidecategories(Navigation);

event OnSetMesh(SeqAct_SetMesh Action)
{
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
}

Event SetMesh(OLHero Caller)
{
    local SkeletalMesh Body;
    local StaticMesh Head;
    local OLGameTemplate Gameinfo;

    Gameinfo = OLGameTemplate(Worldinfo.Game);

    Body =  Gameinfo.HeroBody;
    WorldInfo.Game.BroadcastHandler.Broadcast(self, "Enabling Custom Model");
    Caller.Mesh.SetSkeletalMesh(Body);
    Caller.ShadowProxy.SetSkeletalMesh(Body);
}