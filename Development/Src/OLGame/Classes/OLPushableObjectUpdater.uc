class OLPushableObjectUpdater extends BrushBuilder;

event bool Build()
{
    Example();
    return false;
}

function Example()
{
    local WorldInfo WI;
    local OLPushableObject SMA;
	local vector X;

    WI = class'Engine'.static.GetCurrentWorldInfo();
    foreach WI.AllActors(class'OLPushableObject', SMA)
    {
		X.x = SMA.BaseTranslation;
        SMA.mesh.SetTranslation(X);
    }
}

defaultproperties
{
    BitmapFilename="Cancel"
    GroupName=OL Tools
    ToolTip="Update Pushable Objects"
}