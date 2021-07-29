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

var Array<TasInput> CurrentSavedInputs;
var Engine Engine;
var TasRecording Recording;
var float SavedDeltaTime;
var JsonObject JSON;

Event Tick(Float DeltaTime)
{
    SavedDeltaTime=DeltaTime;
}

Event onInitiallize()
{
    Engine=class'Engine'.static.GetEngine();
}

Function Input(Keybind KeyPress, EInputEvent InputEvent, bool bWasAxis)
{
    local TasInput Input;

    if (InputEvent==IE_Repeat) {Return;}

    Input.KeyPress = KeyPress;
    Input.InputEvent = InputEvent;
    Input.Axis.bWasAxis = bWasAxis;
    Input.Time=SavedDeltaTime;

    CurrentSavedInputs.AddItem(Input);

    /*`log("---------------");
    `log("Key: " $ KeyPress.Name);
    `log("InputEvent: " $ InputEvent);*/

    return;
}

Function SaveRecording()
{
    if (Recording==None)
    {
        `log("Need to make Recording");
    }
    Recording = Spawn( Class'TasRecording' );

    Recording.ExportRecording(CurrentSavedInputs, "Funni");

    return;
}