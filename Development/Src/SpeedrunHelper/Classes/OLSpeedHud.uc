Class OLSpeedHud extends OLHud;

function DrawHUD()
{
    Local OLCheckpoint Checkpoint;
    local OLGameplayMarker GameplayMarker;
    local string string;
    local int index;

    Super.DrawHUD();

    if (OLSpeedController(PlayerOwner).Enabled)
    {
        foreach AllActors(class'OLCheckpoint', Checkpoint)
        {
            string = string(Checkpoint.Class) $ "\nName: " $ String(Checkpoint.CheckpointName) $ "\nChapter: " $ Localize("Locations", String(Checkpoint.Tag), "OLGame");
            if (OLGame(WorldInfo.Game).CurrentCheckpointName==Checkpoint.CheckpointName) {string = string $ "\nCurrent Checkpoint";}
            WorldTextDraw(string, Checkpoint.location, OLSpeedController(PlayerOwner).Max_View_Distance, 200, vect(100,0,0));
        }
        foreach AllActors(class'OLGameplayMarker', GameplayMarker)
        {
            string = string(GameplayMarker.class) $ "\n";
            Switch(GameplayMarker.class)
            {
                Case class'OLRecordingMarker':
                    string = string $ "Name: " $ String(OLRecordingMarker(GameplayMarker).MomentName);
                    if ( contains(OLSpeedController(PlayerOwner).CompletedRecordingMoments, OLRecordingMarker(GameplayMarker).MomentName) )
                    {
                        string = string $ "\nRecorded";
                    }
                    WorldTextDraw(string, GameplayMarker.location, OLSpeedController(PlayerOwner).Max_View_Distance, 200, vect(100,0,0));
                break;

                Case class'OLAIVaultMarker':
                break;

                Default:
                    WorldTextDraw(string, GameplayMarker.location, OLSpeedController(PlayerOwner).Max_View_Distance, 200, vect(100,0,0));
                break;
            }
        }
    }
}

Function WorldTextDraw(string Text, vector location, Float Max_View_Distance, float scale, optional vector offset)
{
    Local Vector DrawLocation;
    Local Vector CameraLocation;
    Local Rotator CameraDir;
    Local Float Distance;

    PlayerOwner.GetPlayerViewPoint( CameraLocation, CameraDir );
    distance = ScalebyCam( VSize(CameraLocation - Location) ) ;
    DrawLocation = Canvas.Project(Location);
    if (vector(CameraDir) dot (location - CameraLocation) > 0.0 && distance < Max_View_Distance)
    {
        Scale = Scale / Distance;
        Canvas.SetPos(DrawLocation.X + (Offset.X * Scale), DrawLocation.Y + (Offset.Y * Scale), DrawLocation.Z + (Offset.Z * Scale));
        Canvas.DrawText(Text, false, Scale, Scale);
    }
}

Function Float ScalebyCam(Float Float)
{
    Local Float Scale;
    Scale = ( PlayerOwner.GetFOVAngle() / 100);

    Return Float * Scale;
}

Function Bool Contains(Array<Name> Array, Name find)
{
    Switch(Array.Find(find) )
    {
        case -1:
            Return False;
        break;

        Default:
            Return true;
        Break;
    }
}