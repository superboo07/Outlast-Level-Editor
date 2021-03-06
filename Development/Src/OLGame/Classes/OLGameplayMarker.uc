/*******************************************************************************
 * OLGameplayMarker generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLGameplayMarker extends Actor
    native
    placeable
    classgroup(OL,Gameplay)
    hidecategories(Navigation);

var() bool bEnabled;
simulated function OnToggle(SeqAct_Toggle Action)
{
}

defaultproperties
{
    bEnabled=true
    Components(0)=none
    bEdShouldSnap=true
	Begin Object Class=SpriteComponent Name=Sprite44
        Sprite=Texture2D'OLEditorResources.EditorSprites.OLGameplayMarker_Sprite'
        HiddenGame=true
        HiddenEditor=false
        AlwaysLoadOnClient=False
        AlwaysLoadOnServer=False
        SpriteCategoryName="GSD"
        Scale=.05
    End Object
	Components.Add(Sprite44)
}