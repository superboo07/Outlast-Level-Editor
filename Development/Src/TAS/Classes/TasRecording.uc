class TasRecording extends Actor;

var Name Checkpoint;

var array<TasInput> SavedInputs;

Function ExportRecording(array<TasInput> Inputs, string FileName)
{
    Checkpoint='Test';
    SavedInputs=Inputs;
    class'Engine'.static.GetEngine().BasicSaveObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);
    `log("Saving TAS");
}

Function DebugPrintSavedRecordingToLog(string FileName)
{
    class'Engine'.static.GetEngine().BasicLoadObject(Self, "../../OLGame/User/" $ FileName $ ".OLTAS", false, 1);

    
}