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
var Engine Engine;
var TasRecording Recording;

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
    CurrentGame = TasGame(WorldInfo.Game);
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
        bIsRecording = true;
    }
    Recording.Inputs.Length = 0;
    Recording.Checkpoint = CurrentGame.CurrentCheckpointName;
    ElapsedRecordingTime = 0;
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