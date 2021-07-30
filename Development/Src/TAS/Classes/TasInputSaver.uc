class TasInputSaver extends Actor
config(SavedInputs);

struct Axis
{
    var bool bWasAxis;
    var float MouseX, MouseY;
};

struct TasInput
{
    var KeyBind KeyPress;
    var EInputEvent InputEvent;
    var float Time;
    var Axis Axis;
};

var bool bIsRecording;
var bool IsPlayback;

var OLGame CurrentGame;
var OLHero Hero;
var Engine Engine;
var TasRecording Recording;

var TasPlayerInput Input;

var float ElapsedRecordingTime;
var float PlaybackTime;

var int CurrentPlaybackInputIndex;
var int MaxPlaybackInputs;

event Tick(Float DeltaTime)
{
    if(bIsRecording)
    {
        ElapsedRecordingTime += DeltaTime;
    }
}

event OnInitialize()
{
    Engine=class'Engine'.static.GetEngine();
    bIsRecording = false;
    ElapsedRecordingTime = 0;
    PlaybackTime = 0;
    CurrentPlaybackInputIndex = 0;
}

function RecordInput(Keybind KeyPress, EInputEvent InputEvent, bool bWasAxis)
{
    local TasInput Input;

    if (InputEvent == IE_Repeat) 
    {
        return;
    }

    Input.KeyPress = KeyPress;
    Input.InputEvent = InputEvent;
    Input.Axis.bWasAxis = bWasAxis;
    Input.Time = ElapsedRecordingTime;

    Recording.Inputs.AddItem(Input);

    return;
}

function StartRecording()
{
    if (bIsRecording) {`log("Already Recording"); return;}

    if (Recording == None)
    {
        Recording = Spawn( Class'TasRecording' );
    }

    Recording.Inputs.Length = 0;
    Recording.Checkpoint = CurrentGame.CurrentCheckpointName;
	Recording.SavedPosition.Location=Hero.Location;
	Recording.SavedPosition.Rotation=Vect2D(Hero.Rotation.Yaw, Hero.Camera.ViewCS.Pitch);
    ElapsedRecordingTime = 0;
    bIsRecording = true;
    `log("Started TAS Recording");
}

function StopRecording()
{
    if (!bIsRecording) {`log("Please start a recording before ending"); return;}
    bIsRecording = false;
    if (Recording == None)
    {
        return;
    }

    Recording.ExportRecording("Inputs");
    `log("Stopped TAS Recording");
}

function StartPlayback()
{
    if (Recording == None)
    {
        `log("Need to make Recording");
        Recording = Spawn( Class'TasRecording' );
    }
    Recording.LoadRecording("Inputs");
    MaxPlaybackInputs = Recording.Inputs.Length;
    `log("Max inputs: " $ MaxPlaybackInputs);
    CurrentPlaybackInputIndex = 0;
    PlaybackTime = 0;
    Hero.SetLocation( Recording.SavedPosition.Location );
	Hero.SetRotation( MakeRotator( Hero.Rotation.Pitch, Recording.SavedPosition.Rotation.X, Hero.Rotation.Roll ) );
	Hero.Camera.ViewCS.Pitch=Recording.SavedPosition.Rotation.Y;

    IsPlayback = true;
}

function StopPlayback()
{
    IsPlayback = false;
}

function LogRecording()
{
    if (Recording == None)
    {
        `log("Need to make Recording");
        Recording = Spawn( Class'TasRecording' );
    }

    Recording.DebugPrintSavedRecordingToLog("Inputs");
}