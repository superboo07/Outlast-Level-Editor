class OLCustomPlayerController extends OLPlayerController;

//Override Set Mesh and Set Material Events to prevent the game from switching out the custom model.
event OnSetMesh(SeqAct_SetMesh Action)
{
    local OLCustomGame Gameinfo;
    local OLPlayerModel PlayerModel;

    GameInfo = OLCustomGame(Worldinfo.Game);
    PlayerModel = OLPlayerModel(DynamicLoadObject(Gameinfo.PlayerModel, class'OLPlayerModelDef'));

    if (PlayerModel.Block_Model_Changes==False)
    {
        super.OnSetMesh(Action);
    }
}

Function OnSetMaterial(SeqAct_SetMaterial Action)
{
    local OLCustomGame Gameinfo;
    local OLPlayerModel PlayerModel;
    local OLCustomHero Hero;

    GameInfo = OLCustomGame(Worldinfo.Game);
    PlayerModel = OLPlayerModel(DynamicLoadObject(Gameinfo.PlayerModel, class'OLPlayerModelDef'));
    Hero = OLCustomHero(HeroPawn);

    if (PlayerModel.Block_Model_Changes==False)
    {
        Hero.OnSetMaterial(Action);
    }
}