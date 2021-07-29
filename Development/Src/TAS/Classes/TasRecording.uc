class TasRecording extends Actor;

var Name Checkpoint;

var array<TasInput> SavedInputs;

function ExportRecording(array<TasInput> Inputs, string FileName)
{
    Checkpoint='Test';
    SavedInputs=Inputs;
    class'Engine'.static.GetEngine().BasicSaveObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);
    `log("Saving TAS");
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

    foreach SavedInputs(Input)
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