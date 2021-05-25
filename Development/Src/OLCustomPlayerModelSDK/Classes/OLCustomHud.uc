Class OLCustomHud extends OLHUD;

var string ModString;
var string ExtraString;

function DrawHUD()
{
    local OLCustomGame Gameinfo;
    local Vector2D TextSize;
    local bool Modify_Extra;

    Gameinfo = OLCustomGame(Worldinfo.Game);
    Modify_Extra = Gameinfo.Modify_Extra;

    super.DrawHud();

    Canvas.SetPos(0,0);
    Canvas.TextSize(ModString, TextSize.X, TextSize.Y);
    Canvas.DrawText(ModString);

    if (Modify_Extra == true)
    {
        Canvas.SetPos(0,15);
        Canvas.TextSize(ExtraString, TextSize.X, TextSize.Y);
        Canvas.DrawText(ExtraString);
    }
}

DefaultProperties
{
    ModString = "This game has a custom player pawn installed.";
    ExtraString = "Gameplay Variables have been changed.";
}