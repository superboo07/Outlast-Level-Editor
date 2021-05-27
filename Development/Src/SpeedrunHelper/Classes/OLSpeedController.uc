Class OLSpeedController extends OLPlayerController
Config(Game);

var config float Refresh;

Exec Function Deploy()
{
    local OLGameplayMarker GameplayMarker; //Current Gameplay Marker
    local spriteview Just_Spawned; //Store Current Sprite here
	local vector Location;
    local OLCheckpoint Checkpoint; //Current Checkpoint
    local Texture2D Sprite; //Current Texture

    local name Fuck; //Use this to trick the spawn function into working

    `log("Updating View");

    foreach AllActors(class'spriteview', Just_Spawned)
    {
        Just_Spawned.Destroy();
    }

    foreach AllActors(class'OLGameplayMarker', GameplayMarker)
    {
        Location = GameplayMarker.Location;
        Just_Spawned = Spawn(Class'SpriteView', GameplayMarker, Fuck, Location);
        Switch(GameplayMarker.Class)
        {
            Case class'OLLedgeMarker':
                sprite=Texture2D'OLEditorResources.EditorSprites.OLLedgeMarker_Sprite';
            Break;

            Case class'OLRecordingMarker':
                sprite=Texture2D'OLEditorResources.EditorSprites.OLRecordingMarker_Sprite';
            Break;

            Case class'OLCornerMarker':
                sprite=Texture2D'OLEditorResources.EditorSprites.OLCornerMarker_Sprite';
            Break;

            Case class'OLBed':
                sprite=Texture2D'OLEditorResources.EditorSprites.OLBed_Sprite';
            Break;

            Case class'OLCSA':
                sprite=Texture2D'OLEditorResources.EditorSprites.OLCSA_Sprite';
            Break;

            Default:
                Sprite=Texture2D'OLEditorResources.EditorSprites.OLGameplayMarker_Sprite';
            Break;
        }
        Just_Spawned.Sprite.SetSprite(Sprite);
    }

    foreach AllActors(class'OLCheckpoint', Checkpoint)
    {
        Location = Checkpoint.Location;
        Just_Spawned = Spawn(Class'SpriteView', Checkpoint, Fuck, Location);
        Just_Spawned.Sprite.SetSprite(Texture2D'OLEditorResources.EditorSprites.OLCheckpoint_Sprite');
    }

    WorldInfo.Game.SetTimer(Refresh, false, 'Deploy', self);
}