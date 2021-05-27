Class SpriteView extends Actor;

var SpriteComponent Sprite;

DefaultProperties
{
    Begin Object Class=DynamicSpriteComponent Name=Sprite44
        Sprite=Texture2D'OLEditorResources.EditorSprites.OLGameplayMarker_Sprite'
        HiddenGame=false
        HiddenEditor=false
        AlwaysLoadOnClient=False
        AlwaysLoadOnServer=False
        SpriteCategoryName="GSD"
        Scale=.05
    End Object
    Sprite=Sprite44
	Components.Add(Sprite44)
}
