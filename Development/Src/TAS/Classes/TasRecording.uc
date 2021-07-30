class TasRecording extends Actor;

var Name Checkpoint;
var array<TasInput> Inputs;

function ExportRecording(string FileName)
{
    class'Engine'.static.GetEngine().BasicSaveObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);
    `log("Saving TAS to " $ FileName);
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