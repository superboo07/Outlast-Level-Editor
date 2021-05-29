Class OLSpeedController extends OLPlayerController
Config(Tool);

var config float Refresh;
var config float Max_View_Distance;
var config Array<String> Ignore_Actors;

var bool Enabled;
var bool Full_Bright;

Exec Function ShowUseful()
{
    ConsoleCommand("Show COLLISION");
    ConsoleCommand("Stat LEVELS");
}

Exec Function RestartRun()
{
    ConsoleCommand("StreamMap Intro_Persistent");
    StartNewGameAtCheckpoint("Admin_Gates", true);
}

Exec Function ShowFPS()
{
    ConsoleCommand("Stat FPS");
}

Exec Function ToogleFreeCam()
{
    if ( UsingFirstPersonCamera() )
    {
        ConsoleCommand("Camera Freecam");
    }
    else
    {
        ConsoleCommand("Camera Default");
    }
}

Exec Function ToogleDebugView() //Toggle Visibility
{
    local spriteview Just_Spawned;

    Switch(Enabled)
    {
        Case True: //Toggle Off
            Enabled = False;
            foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned Sprites
            {
                Just_Spawned.Destroy();
            }
        Break;

        Case False: //Toggle On
            Enabled = True;
            View();
        Break;
    }

}

Function View()
{
    local OLGameplayMarker GameplayMarker; //Current Gameplay Marker
    local spriteview Just_Spawned; //Store Current Sprite here
    local OLCheckpoint Checkpoint; //Current Checkpoint
    local Texture2D Sprite; //Current Texture
    local vector Location;
    local string String;
    local bool ignore;

    local name Fuck; //Dummy name piece of shit fuck to force the spawn command into submission.

    foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned sprites
    {
        Just_Spawned.Destroy();
    }

    if (Enabled==true)
    {
        foreach AllActors(class'OLGameplayMarker', GameplayMarker)
        {
            Location = GameplayMarker.Location;
            ignore=false;

            if (ContainsString(Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if Ignore_Actor array contains this class, if it does tell it to fuck off.

            if (Ignore==true)
            {
                Break;
            }

            Just_Spawned = Spawn(Class'SpriteView', GameplayMarker, Fuck, Location);
            Just_Spawned.SetBase(GameplayMarker);
            
            Switch(GameplayMarker.Class) //Select Sprite for Gamemarker based on class, and use a switch because i'm not yandare dev. 
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

        WorldInfo.Game.SetTimer(Refresh, false, 'View', self);
    }
}

Function Bool ContainsString(Array<String> Array, String find)
{
    Switch(Array.Find(find))
    {
        case -1:
            Return False;
        break;

        Default:
            Return true;
        Break;
    }
}

event StartNewGameAtCheckpoint(string CheckpointStr, bool bSaveToDisk)
{
    local OLCheckpoint CheckCP, startCP;
    local OLHero Hero;
    local OLSpeedGame CurrentGame;
    local OLEngine Engine;

    foreach AllActors(class'OLCheckpoint', CheckCP)
    {
        if(Caps(string(CheckCP.CheckpointName)) == Caps(CheckpointStr))
        {
            startCP = CheckCP;
            break;
        }        
    }    
    if(startCP != none)
    {
        if(HUD.IsMainMenuOpen())
        {
            StopAllSounds();
        }
        HUD.HideMenu();
        Hero = HeroPawn;
        UnPossess();
        if(Hero != none)
        {
            Hero.Destroy();
        }
        ClearAllProgress();
        Engine = OLEngine(class'Engine'.static.GetEngine());
        CurrentGame = OLSpeedGame(WorldInfo.Game);
        if(CurrentGame != none)
        {
            if((Engine != none) && !Engine.UsingFixedSaveLocation())
            {
                Engine.SaveCheckpoint(startCP.CheckpointName, bSaveToDisk);
            }
            CurrentGame.CurrentCheckpointName = startCP.CheckpointName;
            CurrentGame.RestartPlayer(self);
        }
    }
}

DefaultProperties
{
    Refresh=1
    Max_View_Distance=500
    Ignore_Actors="OLPreferredPathMarker", "OLAIVaultMarker"
}