class TasRecording extends Actor;

struct Saved_Position
{
	var vector Location;
	var Vector2D Rotation;
	var string Name;
};

var Name Checkpoint;
var array<TasInput> Inputs;
var Saved_Position SavedPosition;

function ExportRecording(string FileName)
{
    class'Engine'.static.GetEngine().BasicSaveObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);
    `log("Saving TAS to " $ FileName);
}

function LoadRecording(string FileName)
{
    `log("Loading TAS Recording: " $ FileName);
    class'Engine'.static.GetEngine().BasicLoadObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);
    `log("Loaded Recording");
}

/**
 * Dumps the TAS file to the log
 * 
 * @param FileName The name of the Tas file to dump
 */

function DebugPrintSavedRecordingToLog(string FileName)
{
    local TasInput Input;

    class'Engine'.static.GetEngine().BasicLoadObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);

    `log("Printing file '" $ FileName $ "' to the log");
    `log("Checkpoint: " $ Checkpoint);
    `log("Starting Location: " $ SavedPosition.Location);
    `log("--------------------------------------------");

    foreach Inputs(Input)
    {
        `log("  KeyBind: " $ Input.KeyPress.Name);
        `log("  InputType: " $ Input.InputEvent);
        `log("  Time: " $ Input.Time);
        `log("  Axis: {");
        `log("      IsAxis: " $ Input.Axis.bWasAxis);
        `log("      MouseX: " $ Input.Axis.MouseX);
        `log("      MouseY: " $ Input.Axis.MouseY);
        `log("  }");
        `log("--------------------------------------------");
    }
}