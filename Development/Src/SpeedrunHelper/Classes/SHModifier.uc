class SHModifier extends Actor
config(Tool);

var config float Refresh;

Event onEnable();

Event onDisable();

Event onTimer();

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