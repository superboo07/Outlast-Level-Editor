class SHModifier extends Actor
config(Tool);

var config float Refresh;

//Called every time the Modifier is enabled
Event onEnable();

//Called every time the modifier is disabled
Event onDisable();

//Called everytime the timer hits the value specified in 'Refresh'
Event onTimer();

//Used for Drawing to the HUD (duh)
Event onDrawHUD(SHHUD Caller);

Function StartTimer()
{
    local SHGame Game;

    Game = SHGame(WorldInfo.Game);

    onEnable();
    onTimer();
    Game.SetTimer(Refresh, true, 'onTimer', self);
}

Function EndTimer()
{
    local SHGame Game;

    Game = SHGame(WorldInfo.Game);

    Game.ClearTimer('onTimer', self);
    onDisable();
}