Class OLSpeedHud extends OLHud;

Struct ButtonStruct
{
    var string Name;
    var string ConsoleCommand;
    var vector2d Start_Points;
    var vector2d End_Point;
    var vector2D Location;
    var vector2D Offset;
    var vector2D ClipStart;
    var vector2D ClipEnd;
    var bool template;
    var int Row;
    Var int Column;
};

Struct RGBA
{
    var Byte Red;
    var Byte Green;
    var Byte Blue;
    var Byte Alpha;
};

Enum Menu
{
    Normal,
    Show,
    Collision,
    Cheats,
    SavePositionSelect,
    SaveOrLoad,
    Funny,
    PlayerModel
};

var bool Show_Menu;
var bool Pressed;
var bool AlreadyCommited;
var string Command;
var array<ButtonStruct> Buttons;
var ButtonStruct Previous_Button;
var Menu CurrentMenu;
var Collision_Type Current_Collision;

delegate ButtonPress();

function DrawHUD() //Called every frame
{
    local OLSpeedController Controller;
    Local OLCheckpoint Checkpoint;
    local OLGameplayMarker GameplayMarker;
    local OLPickableObject PickableObject;
    local OLEnemyPawn EnemyPawn;
    local SkeletalMeshActor SkeletalMesh0;
    local OLDoor Door;
    local OLGame CurrentGame;
    local string string;
    local string PlayerDebug;

    Super.DrawHUD(); //Run Parent Function First

    Controller = OLSpeedController(PlayerOwner); //Cast to OLSpeedController using 'PlayerOwner'
    CurrentGame = OLSpeedGame(WorldInfo.Game);
    Buttons.Remove(0, Buttons.Length);

    PlayerDebug = "This game has the Outlast Speedrun Helper installed" $ Controller.Current_SkeletalMesh;

    if (Controller.Enabled) 
    {

        PlayerDebug = PlayerDebug $ "\n\nPlayer Debug Info: \nCurrent Collision Size: " $ OLHero(Controller.Pawn).CylinderComponent.CollisionRadius $ "\nHealth: " $ OLSpeedPawn(Controller.Pawn).Health;
        foreach AllActors(class'OLCheckpoint', Checkpoint)
        {
            string = string(Checkpoint.Class) $ "\nName: " $ String(Checkpoint.CheckpointName) $ "\nChapter: " $ Localize("Locations", String(Checkpoint.Tag), "OLGame"); //Pull Chapter Name from Localization Files.
            if (OLGame(WorldInfo.Game).CurrentCheckpointName==Checkpoint.CheckpointName) {string = string $ "\nCurrent Checkpoint";} //If the Current Chapter is equal to the ChapterName of this Checkpoint, print Current Chapter.
            WorldTextDraw(string, Checkpoint.location, Controller.Max_View_Distance, 200, vect(100,0,0));
        }

        foreach AllActors(class'OLGameplayMarker', GameplayMarker)
        {
            if ( ContainsString( controller.Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if the Ignore_Actor array from the player controller contains this class, if it does tell it to fuck off.

            string = string(GameplayMarker.class) $ "\n";
            if (GameplayMarker.BEnabled)
            {
                string = string $ "Enabled\n";
            }
            else
            {
                string = string $ "Disabled\n";
            }
            Switch(GameplayMarker.class) //Use Switch because i'm not Yandare Dev.
            {
                Case class'OLRecordingMarker':
                    if (CurrentGame.IsPlayingDLC() )
                    {
                        string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrativeDLC");
                    }
                    else
                    {
                        string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrative"); /*Pull recording name from localization*/
                    }
                    string = string $ "\nName: " $ String(OLRecordingMarker(GameplayMarker).MomentName);
                    string = string $ "\nNotification Delay: " $ OLRecordingMarker(GameplayMarker).NotificationDelay $ "\nRecording Time: " $ OLRecordingMarker(GameplayMarker).MinRecordingDuration;
                    if ( ContainsName(Controller.CompletedRecordingMoments, OLRecordingMarker(GameplayMarker).MomentName) ) { string = string $ "\nRecorded"; }
                    goto Print;
                break;

                case class'OLCSA':
                    string = string $ "Required Item: " $ OLCSA(GameplayMarker).RequiredItem $ "\nMax Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount $ "\nRemaining Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount - OLCSA(GameplayMarker).TriggerCount;
                    goto Print;
                break;

                Default: goto Print; break;
            }
            Print: WorldTextDraw(string, GameplayMarker.location, Controller.Max_View_Distance, 200, vect(100,0,0));
        }

        foreach allactors(Class'OLPickableObject', PickableObject)
        {
            string = string(PickableObject.class) $ "\n";
            if (PickableObject.bUsed==false && PickableObject.bHidden==false)
            {
                Switch(PickableObject.Class) //Use Switch because i'm not Yandare Dev.
                {
                    case class'OLGameplayItemPickup':
                        string = string $ "Item Name: " $ string( OLGameplayItemPickup(PickableObject).ItemName);
                        Goto Print;
                    break;

                    case class'OLCollectiblePickup':
                        if (CurrentGame.IsPlayingDLC() )
                        {
                            string = string $ "Title: " $ Localize("Documents", String(OLCollectiblePickup(PickableObject).CollectibleName) $ "_Title", "OLNarrativeDLC");
                        }
                        else
                        {
                            string = string $ "Title: " $ Localize("Documents", String(OLCollectiblePickup(PickableObject).CollectibleName) $ "_Title", "OLNarrative"); /*Pull recording name from localization*/
                        }
                        string = string $ "\nCollectable Name: " $ String(OLCollectiblePickup(PickableObject).CollectibleName); 
                        Goto Print;
                    break;

                    Default: Goto Print;
                }
                Print: WorldTextDraw(string, PickableObject.location, Controller.Max_View_Distance, 150, vect(0,0,0));
            }
        }

        foreach allactors(Class'OLEnemyPawn', EnemyPawn)
        {
            string = string(EnemyPawn.class) $ "\n";
            string = string $ "Should Attack: " $ EnemyPawn.Modifiers.bShouldAttack $ "\nDisableKnockbackFromPlayer: " $ EnemyPawn.Modifiers.bDisableKnockbackFromPlayer $ "\nEnemy Mode: " $ EnemyPawn.EnemyMode $ "\nBehavior Tree: " $ EnemyPawn.BehaviorTree;
            WorldTextDraw(string, EnemyPawn.location, Controller.Max_View_Distance, 200, vect(0,-450,0));
        }

        foreach allactors(Class'OLDoor', Door)
        {
            WorldTextDraw(String(Door.CollisionComponent.CollideActors), Door.location, Controller.Max_View_Distance, 200, vect(0,-450,0));
        }

    }

    ScreenTextDraw(PlayerDebug, vect2d(0,0));

    if (Controller.Collision_Type_Override!=Normal && OLHero(Controller.Pawn).CylinderComponent.CollisionRadius==30)
    {
        Controller.SetPlayerCollisionType(Controller.Collision_Type_Override);
    }
    if (Show_Menu)
    {
        Save_Position_Interface();
        return;
    }
}

Event Save_Position_Interface()
{
    local OLSpeedInput PlayerInput;
    local Texture2D MouseTexture;
    local Vector2D StartClip;
    local Vector2D EndClip;
    local OLSpeedController Controller;

    Controller = OLSpeedController(PlayerOwner);
    PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);
    MouseTexture = Texture2D'menuassets.MouseCursor';

    DrawScaledBox( Vect2D(640 - 250, 250), Vect2D(500, 250),  MakeRGBA(0,0,125,255), StartClip, EndClip);

    EndClip = EndClip;
    Canvas.SetPos( ( 640 - 250 ) / 1280.0f * Canvas.SizeX, 250 / 720.0f * Canvas.SizeY);
    canvas.SetDrawColor(255,255,255,255);
    Canvas.DrawRect( 500 / 1280.0f * Canvas.SizeX , 10 / 720.0f * Canvas.SizeY );

    ScreenTextDraw(Command, vect2D(640 - 250, 250 ), MakeRGBA(125,125,125,255) );

    Switch(CurrentMenu)
    {
        case Normal:
        AddButton("Load Checkpoint", "LoadCheckpoint ", vect2d(425, 275),, StartClip, EndClip, true);
        AddButton("Uncap FPS", "UNCAPFPS",, true);
        AddButton("Cheats", "SetMenu Cheats",, true);
        AddButton("Show Debug", "SetMenu Show",, true);
        AddButton("The Funni's", "SetMenu Funny",, true);
        AddButton("Player Model: " $ Controller.PlayerModel, "SetMenu PlayerModel",, true);
        AddButton("Position Saver", "SetMenu SavePositionSelect",, true );
        break;

        case SavePositionSelect:
        ScreenTextDraw("Select a position", vect2D(640, 270 ), MakeRGBA(125,125,125,255),,, true );
        AddButton(Vectortostring(Controller.Saved_Positions[1].Location), "Check_Position 1 | SetMenu SaveOrLoad", vect2d(425, 275),, StartClip, EndClip);
        AddButton(Vectortostring(Controller.Saved_Positions[2].Location), "Check_Position 2 | SetMenu SaveOrLoad", vect2d(425, 275), true);
        AddButton(Vectortostring(Controller.Saved_Positions[3].Location), "Check_Position 3 | SetMenu SaveOrLoad", vect2d(425, 275), true);
        AddButton(Vectortostring(Controller.Saved_Positions[4].Location), "Check_Position 4 | SetMenu SaveOrLoad", vect2d(425, 275), true);
        AddButton("Go Back", "SetMenu Normal", , true);
        break;

        case SaveOrLoad:
        ScreenTextDraw("Location: " $ Controller.Saved_Positions[Controller.Selected_Save].Location $ "\nRotation: " $ Controller.Saved_Positions[Controller.Selected_Save].Rotation, vect2D(750, 350 ), MakeRGBA(125,125,125,255),,, true );
        AddButton("Save", "Save_Position " $ Controller.Selected_Save, vect2d(425, 275),, StartClip, EndClip);
        AddButton("Load", "Load_Position " $ Controller.Selected_Save $ " | SetMenu Normal | OpenConsoleMenu 0", vect2d(425, 275), true);
        AddButton("Go Back", "SetMenu SavePositionSelect", , true);
        break;

        case Show:
        AddButton("FPS", "Stat FPS", vect2d(425, 275),, StartClip, EndClip);
        AddButton("Level Information", "Stat Levels", , true);
        AddButton("Actor Debug Info", "ToogleDebugView", , true);
        AddButton("Collision", "Show Collision", , true);
        AddButton("Volumes", "Show Volumes", , true);
        AddButton("Fog", "Show Fog", , true);
        AddButton("Level Coloration", "Show Levelcoloration", , true); 
        AddButton("Post Processing", "Show PostProcess", , true); 
        AddButton("Go Back", "SetMenu Normal", , true);
        break;

        case Collision:
        ScreenTextDraw("Thank you G40sty for helping with the Player collision changer", vect2D(600, 490 ) );

        AddButton("Normal", "SetPlayerCollisionType Normal | SetMenu Cheats", vect2d(425, 275),, StartClip, EndClip );
        AddButton("Vaulting", "SetPlayerCollisionType Vault | SetMenu Cheats", , true );
        AddButton("Door", "SetPlayerCollisionType Door | SetMenu Cheats", , true );
        AddButton("Shimmy", "SetPlayerCollisionType Shimmy | SetMenu Cheats", , true );
        AddButton("Go Back", "SetMenu Cheats", , true);
        break;

        case Cheats:

        AddButton("Kill all enemys (May break scripted sequences)", "KillAllEnemys",vect2d(425, 275),, StartClip, EndClip );
        AddButton("Freecam: " $ !Controller.UsingFirstPersonCamera(), "ToogleFreeCam",, true);
        AddButton("Override Player Collider Size: " $ OLSpeedController(PlayerOwner).Collision_Type_Override, "SetMenu Collision",, true );
        AddButton("Godmode: " $ OLSpeedPawn(PlayerOwner.Pawn).GodMode, "ToggleGod",, true );
        AddButton("Toggle Death Bounds: " $ OLSpeedPawn(PlayerOwner.Pawn).DisableKillBound, "ToogleKillBound",, true );
        AddButton("Unlock all doors: " $ Controller.DoorUnlocker, "UnlockDoorsToggle",, true );
        AddButton("Go Back", "SetMenu Normal", , true);
        break;

        Case Funny:
        AddButton("Make Everyone Father Martin: " $ Controller.Martin, "MartinifyToggle",vect2d(425, 275),, StartClip, EndClip );
        AddButton("Allow Wernikie Skip: " $ Controller.WernikSkipEnable, "WernikSkipToggle", , true);

        AddButton("Go Back", "SetMenu Normal", , true);
        Break;

        Case PlayerModel:
        AddButton("Miles", "UpdatePlayerModel Miles",vect2d(425, 275),, StartClip, EndClip );
        AddButton("Miles No Fingers", "UpdatePlayerModel MilesNoFingers",, true);
        AddButton("WaylonIT", "UpdatePlayerModel WaylonIT",, true);
        AddButton("Waylon Prisoner", "UpdatePlayerModel WaylonPrisoner",, true);
        AddButton("Waylon Nude", "UpdatePlayerModel Nude",, true);
        AddButton("No Override", "UpdatePlayerModel No_Override",, true);
        AddButton("Go Back", "SetMenu Normal",, true);
        break;
    }
    
    //Draw mouse last
    Canvas.SetPos(PlayerInput.MousePosition.X, PlayerInput.MousePosition.Y);
    canvas.SetDrawColor(255,255,255,255);
    Canvas.DrawTile(MouseTexture, MouseTexture.SizeX, MouseTexture.SizeY, 0.f, 0.f, MouseTexture.SizeX, MouseTexture.SizeY,, true);
}

Function WorldTextDraw( string Text, vector location, Float Max_View_Distance, float scale, optional vector offset ) //Simple function for drawing text in 3D space
{
    Local Vector DrawLocation; //Location to Draw Text
    Local Vector CameraLocation; //Location of Player Camera
    Local Rotator CameraDir; //Direction the camera is facing
    Local Float Distance; //Distance between Camera and text

    PlayerOwner.GetPlayerViewPoint( CameraLocation, CameraDir );
    distance =  ScalebyCam( VSize(CameraLocation - Location) ); //Get the distance between the camera and the location of the text being placed, then scale it by the camera's FOV. 
    DrawLocation = Canvas.Project(Location); //Project the 3D location into 2D space. 
    if ( vector(CameraDir) dot (location - CameraLocation) > 0.0 && distance < Max_View_Distance )
    {
        Scale = Scale / Distance; //Scale By distance. 
        Canvas.SetPos( DrawLocation.X + ( Offset.X * Scale ), DrawLocation.Y + ( Offset.Y * Scale ), DrawLocation.Z + ( Offset.Z * Scale ) ); //Set the Position of text using the Draw Location and an optional Offset. 
        canvas.SetDrawColor(75,75,75,255);
        Canvas.DrawText(Text, false, Scale, Scale); //Draw the text
    }
}

Function ScreenTextDraw(String Text, Vector2D Location, optional RGBA Color=MakeRGBA(125,125,125), optional Vector2D Scale=Vect2D(1,1), optional bool Scale_Location=True, optional bool center )
{
    local vector2D ScaleCalc;
    local vector2D TextSize;

    ScaleCalc=Vect2d( ( 0.70 * Scale.X ) / 1280.0f * Canvas.SizeX, ( 0.70 * Scale.Y ) / 720.0f * Canvas.SizeY );

    canvas.TextSize(Text, TextSize.X, TextSize.Y, ScaleCalc.X, ScaleCalc.Y);
    if (Center)
    {
        Location=Vect2D(Location.X - (TextSize.X / 2), Location.Y - (TextSize.Y / 2) );
    }
    if (Scale_Location)
    {
        Location=Vect2D(Location.X / 1280.0f * Canvas.SizeX, Location.Y / 720.0f * Canvas.SizeY);
    }
    Canvas.SetPos(Location.X,Location.Y);
    canvas.SetDrawColor(Color.Red,Color.Blue,Color.Green,Color.Alpha);
    Canvas.DrawText(Text, false, ScaleCalc.X, ScaleCalc.Y);
}

Function Float ScalebyCam(Float Float) //Function to scale a float by the players current FOV. 
{
    Local Float Scale;
    Scale = ( PlayerOwner.GetFOVAngle() / 100 );

    Return Float * Scale;
}

Function RGBA MakeRGBA(byte R, byte G, byte B, optional byte A=255)
{
    local RGBA RGBShit;

    RGBShit.Red=R;
    RGBShit.Green=G;
    RGBShit.Blue=B;
    RGBShit.Alpha=A;

    Return RGBShit;
}
Function Bool ContainsName(Array<Name> Array, Name find) //Check if Array contains Name Variable. 
{
    Switch(Array.Find(find) )
    {
        case -1: Return False;

        Default: Return true;
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

function click()
{
    local OLSpeedInput PlayerInput;
    local ButtonStruct buttonvar;
    local IntPoint MousePosition;

    PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);

    MousePosition = PlayerInput.MousePosition;

    foreach Buttons(buttonvar)
    {
        if ( InRange(MousePosition.X, buttonvar.Start_Points.X, buttonvar.End_Point.X) && InRange(MousePosition.Y, buttonvar.Start_Points.Y, buttonvar.End_Point.Y ) )
        {
            if (ButtonVar.Template)
            {
                Command=buttonvar.ConsoleCommand;
                return;
            }
            PlayerOwner.ConsoleCommand(buttonvar.ConsoleCommand);
            return;
        }
    }
    return;
}

Function Commit()
{
    PlayerOwner.ConsoleCommand(Command);
    Command="";
}

Function AddButton(String Name, String ConsoleCommand, optional vector2D Location, optional bool AutoDown=False, optional vector2D Bound_Start, optional vector2D Bound_End, optional bool template)
{
    local vector2D Begin_PointCalc;
    local vector2D End_PointCalc;
    local vector2D Offset;
    local vector2D Center_Vector;
    local vector2D TextSize;
    local RGBA Color;
    local ButtonStruct ButtonBase;
    local ButtonStruct PreviousButton;
    local ButtonStruct FirstButtonInRow;
    local ButtonStruct ButtonInColumn;
    local int Row;
    local int Column;

    canvas.TextSize(Name, TextSize.X, TextSize.Y );

    offset=vect2D( 15 + (TextSize.X / 1.5), 5 + (TextSize.Y / 1.5) );

    if (Buttons.Length==0)
    {
       Row=1;
       Column=1;
    }
    else
    {
        PreviousButton=Buttons[ (Buttons.Length - 1 ) ];
        Row=PreviousButton.Row;
        Column=PreviousButton.Column+1;
        FirstButtonInRow=FindButton(Buttons, Row, 1);
        if (FirstButtonInRow.Row!=-1)
        {
            Bound_Start = FirstButtonInRow.ClipStart;
            Bound_End = FirstButtonInRow.ClipEnd;
            if (AutoDown)
            {
                Location.X = PreviousButton.Location.X;
                Location.Y = (PreviousButton.Location.Y + PreviousButton.Offset.Y) + 10;
                if( !InRange( Scale2dVector(Location + Offset).Y, Bound_Start.Y, Bound_Start.Y + Bound_End.Y) )
                {
                    Location.X = (FirstButtonInRow.Location.X + FirstButtonInRow.Offset.X) + 10;
                    Location.Y = FirstButtonInRow.Location.Y;
                    ++ Row;
                    Column=1;
                }
                else if (Column>1)
                {
                    ButtonInColumn=FindButton(Buttons, (Row - 1), Column);
                    if (ButtonInColumn.Row!=-1)
                    {
                        Location.X = (ButtonInColumn.Location.X + ButtonInColumn.Offset.X) + 10;
                    }
                }
            }
        }
    }

    If ( MouseInbetween(Scale2DVector(Location), Scale2DVector(Location + Offset) ) )
    {
        Color=MakeRGBA(50,50,50,255);
    }
    else
    {
        Color=MakeRGBA(255,255,255,255);
    }

    //Draw the button box
    DrawScaledBox(Location, offset, Color, Begin_PointCalc, End_PointCalc);

    //Get the center of the button
    Center_Vector=vect2D( ( Begin_PointCalc.X + (Begin_PointCalc.X + End_PointCalc.X) ) / 2, ( Begin_PointCalc.Y + ( Begin_PointCalc.Y + End_PointCalc.Y ) ) / 2);

    //Draw Button Text Centered.
    ScreenTextDraw(Name, Center_Vector,  MakeRGBA(75,75,75,255),, false, true );

    //Add the button info to the array
    ButtonBase.Name=Name;
    ButtonBase.ConsoleCommand=ConsoleCommand;
    ButtonBase.Start_Points=Begin_PointCalc;
    ButtonBase.End_Point=vect2d( (Begin_PointCalc.X + End_PointCalc.X), (Begin_PointCalc.Y + End_PointCalc.Y ) );
    ButtonBase.Template=template; //Does button require user input after pressing
    ButtonBase.Location=Location;
    ButtonBase.Offset=Offset;
    ButtonBase.ClipStart=Bound_Start;
    ButtonBase.ClipEnd=Bound_End;
    ButtonBase.Row=Row;
    ButtonBase.Column=Column;

    Buttons.AddItem(ButtonBase);

}

function bool InRange(float Target, Float RangeMin, Float RangeMax)
{
    Return Target>RangeMin && Target<RangeMax;
}

Exec Function SetMenu(Menu Menu)
{
    CurrentMenu=Menu;
}

Function IntPoint GetMousePosition()
{
    local OLSpeedInput PlayerInput;

    PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);

    return PlayerInput.MousePosition;
}

Function Bool Mouseinbetween(Vector2D Vector1, Vector2D Vector2)
{
    local intpoint MousePosition;

    MousePosition=GetMousePosition();
    
    Return InRange(MousePosition.X, Vector1.X, Vector2.X) && InRange(MousePosition.Y, Vector1.Y, Vector2.Y );
}

Function DrawScaledBox(Vector2D Begin_Point, Vector2D End_Point, optional RGBA Color=MakeRGBA(255,255,255,255), optional out Vector2D Begin_Point_Calculated, optional out Vector2D End_Point_Calculated  )
{
    Begin_Point_Calculated = Scale2DVector(Begin_Point);

    End_Point_Calculated = Scale2DVector(End_Point);

    Canvas.SetPos( Begin_Point_Calculated.X, Begin_Point_Calculated.Y);
    canvas.SetDrawColor(Color.Red,Color.Green,Color.Blue,Color.Alpha);
    Canvas.DrawRect( End_Point_Calculated.X, End_Point_Calculated.Y);
}

Function Vector2D Scale2DVector(Vector2D Vector)
{
    Vector.X=Vector.X / 1280.0f * Canvas.SizeX;
    Vector.Y=Vector.Y / 720.0f * Canvas.SizeY;

    Return Vector;
}

Function ButtonStruct FindButton(Array<ButtonStruct> Array, Int Row, Int Column)
{
    local ButtonStruct Button;

    foreach array(Button)
    {
        if (Button.Row==Row)
        {
            if (Button.Column==Column)
            {
                Return Button;
            }
        }
    }
    Button.Row=-1;
    Return Button;
}

exec function HideMenu()
{
    PlayerOwner.ConsoleCommand("OpenConsoleMenu 0");
    super.HideMenu();
}

Function Bool Vector2DInRange(Vector2D Target, Vector2D Vector1, Vector2D Vector2)
{
    Return InRange(Target.X, Vector1.X, Vector2.X) && InRange(Target.Y, Vector1.Y, Vector2.Y );
}

Function String Vectortostring(Vector Target)
{
    local string String;

    string=Target.X $ ", " $ Target.Y $ ", " $ Target.Z;

    Return string;
}