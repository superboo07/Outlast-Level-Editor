class SHOptions extends Actor
config(tool);

Struct SHVariable
{
	var name Option;
	var bool Bool;
	var string ModifierClass;
	var SHModifier Modifier;
};

var config Array<SHVariable> SavedVariables;

Event onInitialize()
{
    local SHVariable Variable;
	local int Index;
    Foreach SavedVariables(Variable)
	{
		if (Variable.Modifier==None)
		{
			SavedVariables[Index].Modifier = Spawn( Class<SHModifier>( DynamicLoadObject(Variable.modifierClass, class'SHModifier') ) );
		}
		if (Variable.Bool==True)
		{
			ExecuteSHOption(Variable);
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

    if (bShouldExecute) { ExecuteSHOption( SavedVariables[Index] ); }

    Return NewBool;
}

Function ExecuteSHOption(SHVariable Option)
{
    local SHGame Game;
	local int Index;

    Game = SHGame(WorldInfo.Game);

	if (option.Modifier==None)
	{
	}

    if (Option.Bool)
    {
        Option.Modifier.StartTimer();
    }
}