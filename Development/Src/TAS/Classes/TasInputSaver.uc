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

var bool IsRecording;
var OLGame CurrentGame;
var Engine Engine;
var TasRecording Recording;
var float SavedDeltaTime;

event Tick(Float DeltaTime)
{
    SavedDeltaTime=DeltaTime;
}

event OnInitialize()
{
    CurrentGame = TasGame(WorldInfo.Game);
    Engine=class'Engine'.static.GetEngine();
    IsRecording = false;
}

function RecordInput(Keybind KeyPress, EInputEvent InputEvent, bool bWasAxis)
{
    local TasInput Input;

    if (InputEvent==IE_Repeat) 
    {
        return;
    }

    Input.KeyPress = KeyPress;
    Input.InputEvent = InputEvent;
    Input.Axis.bWasAxis = bWasAxis;
    Input.Time=SavedDeltaTime;

    Recording.Inputs.AddItem(Input);

    return;
}

function StartRecording()
{
    if (Recording == None)
    {
        Recording = Spawn( Class'TasRecording' );
        IsRecording = true;
    }
    Recording.Inputs.Length = 0;
    Recording.Checkpoint = CurrentGame.CurrentCheckpointName;
    `log("Started TAS Recording");
}

function StopRecording()
{
    IsRecording = false;
    if (Recording == None)
    {
        return;
    }

    Recording.ExportRecording("Inputs");
    `log("Stopped TAS Recording");
}

function LogRecording()
{
     if (Recording==None)
    {
        `log("Need to make Recording");
    }
    Recording = Spawn( Class'TasRecording' );

    Recording.DebugPrintSavedRecordingToLog("Funni");
}