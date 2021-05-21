class OLCustomPlayerController extends OLPlayerController
    hidecategories(Navigation);

//Override Set Mesh and Set Material Events to prevent the game from switching out the custom model.
event OnSetMesh(SeqAct_SetMesh Action)
{
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
}