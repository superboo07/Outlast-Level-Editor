class SHModifier extends Actor
config(Modifiers);

var config float Refresh;
var config string ActionClass;

var SHHero Hero;
var SHGame Game;
var SHPlayerController Controller;

var SHModifierInteraction ModAction;

//Called every time the Modifier is enabled
Event bool onEnable();

//Called every time the modifier is disabled
Event onDisable();

//Called everytime the timer hits the value specified in 'Refresh'
Event onTimer();

//Used for Drawing to the HUD (duh)
Event onDrawHUD(SHHUD Caller);

Function bool StartTimer()
{
    onEnable();
    onTimer();
    Game.SetTimer(Refresh, true, 'onTimer', self);
    if ( ValidateInteraction() ) { Controller.Interactions.AddItem(ModAction); }
    Return true;
}

Function EndTimer()
{
    Game.ClearTimer('onTimer', self);
    onDisable();
}

function Initialize()
{
    Reset();
    ValidateInteraction();
}

function bool ValidateInteraction()
{
    if (ActionClass=="") {Return False;}
    if (ModAction==None)
    {
        ModAction = new(self) Class<SHModifierInteraction>( DynamicLoadObject(ActionClass, Class'Class') );
        ModAction.onAttach();
    }

    Return True;
}