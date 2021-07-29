class SHModifier extends actor;

var float Refresh;
Event onEnable() {}

Event onDisable() {}

Event onTimer() {}

Function StartTimer()
{
    local SHGame Game;

    Game = SHGame(WorldInfo.Game);

    onEnable();
    onTimer();
    Game.SetTimer(Refresh, true, 'onTimer', self);
}