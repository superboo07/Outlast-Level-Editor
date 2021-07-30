class SHOptions extends Actor
config(tool);

Struct SHVariable
{
	var name Option;
	var bool Bool;
	var Class<SHModifier> ModifierString;
	var Class<SHModifier> ModClass;
	var SHModifier Modifier;
};

var config Array<SHVariable> SavedVariables;
var SHPlayerController PlayerController;

Event onInitialize()
{
    local SHVariable Variable;
	local int Index;
    Foreach SavedVariables(Variable)
	{
		if (Variable.Modifier==None)
		{
			//SavedVariables[Index].ModClass = Option.ModifierString;
			Variable.Modifier = Spawn( Variable.ModifierString, self );
			SavedVariables[Index] = Variable;
			`log("FUCK");
		}

		if (Variable.Bool==True)
		{
			ExecuteSHOption(Index);
		}
		++Index;
	}
}

Function Bool GetSHBool(Name Option)
{
	local Int Index;

	Index = SavedVariables.find('Option', Option);
	if (Index==Index_None) 
	{
		return false;
	}
	else
	{
		return SavedVariables[Index].bool;
	}
}

Function SHVariable GetSHOption(Name Option)
{
	local Int Index;
    local SHVariable Empty;

	Index = SavedVariables.find('Option', Option);
	if (Index==Index_None) 
	{
		return Empty;
	}
	else
	{
		return SavedVariables[Index];
	}
}

Exec Function SetSHOption(Name Option, Int Bool)
{
	local Int Index;
	local SHVariable SavedBool;

	FindBool:
	Index = SavedVariables.find('Option', Option);
	if (Index==Index_None) 
	{
		SavedBool.Option=Option;
		SavedVariables.AddItem(SavedBool);
		goto FindBool;
	}

	if (Bool<=Index_None)
	{
		SavedVariables[Index].Bool=!SavedVariables[Index].Bool;
	}
	else
	{
		SavedVariables[Index].Bool=Bool(Bool);
	}
}

Exec Function Bool ToggleSHOption(Name Option, optional Int Toggle=INDEX_NONE, optional bool bShouldExecute=true)
{
	local Int Index;
	local SHVariable SavedBool;
    local bool NewBool;

	FindBool:
	Index = SavedVariables.find('Option', Option);
	if (Index==Index_None) 
	{
		SavedBool.Option=Option;
		SavedVariables.AddItem(SavedBool);
		goto FindBool;
	}
	NewBool=Toggle<=INDEX_NONE ? !SavedVariables[Index].Bool : Bool(Toggle);
    SavedVariables[Index].Bool=NewBool;

    if (bShouldExecute) { ExecuteSHOption( Index ); }

    Return NewBool;
}

Function ExecuteSHOption(int Index)
{
    local SHGame Game;
	local SHVariable option;

    Game = SHGame(WorldInfo.Game);
	option = SavedVariables[Index];

    if (Option.Bool)
    {
        Option.Modifier.StartTimer();
    }
	else
	{
		Option.Modifier.EndTimer();
	}

	SavedVariables[Index] = Option;
}