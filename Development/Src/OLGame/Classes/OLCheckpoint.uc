Class OLCheckpoint extends trigger
	placeable;
	
var() Name CheckpointName;
var() Name PersistentLevelName;

defaultproperties
{
	Begin Object Class=ArrowComponent Name=Arrow2
		HiddenGame=True
		Color=Blue
	End Object
	Components.Add(Arrow2)
	Begin Object Name=Sprite
        Sprite=Texture2D'OLEditorResources.EditorSprites.OLCheckpoint_Sprite'
        HiddenGame=true
        HiddenEditor=false
        AlwaysLoadOnClient=False
        AlwaysLoadOnServer=False
        Scale=.05
    End Object
}