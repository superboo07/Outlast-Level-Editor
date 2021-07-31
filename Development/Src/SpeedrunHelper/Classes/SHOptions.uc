class SHOptions extends Actor
config(tool);

Struct SHVariable
{
	var name Option;
	var bool Bool;
	var Class<SHModifier> ModifierString;
	var SHModifier Modifier;
};

var config Array<SHVariable> SavedVariables;
var SHPlayerController PlayerController;
var SHHero Hero;

Event onInitialize()
{
    local SHVariable Variable;
	local int Index;
    Foreach SavedVariables(Variable)
	{
		if (Variable.Modifier==None)
		{
			Variable.Modifier = Spawn( Variable.ModifierString, self );
			//Variable.Modifier.ValidateInteraction();
			`log("FUCK");
		}
		Variable.Modifier.SetBase(Hero);

		UpdateModifierVariables(Variable);
		SavedVariables[Index] = Variable;

		if (Variable.Bool==True)
		{
			ExecuteSHOption(Index);
		}
		++Index;
	}
}

Function UpdateModifierVariables(Out SHVariable Variable)
{
	Variable.Modifier.Hero=Hero;
	Variable.Modifier.Controller=PlayerController;
	Variable.Modifier.Game=SHGame(Worldinfo.Game);
}

Function Bool GetSHBool(coerce Name Option)
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
        if ( !Option.Modifier.StartTimer() ) 
		{
			option.bool=false;
			goto End;
		}
    }
	else
	{
		Option.Modifier.EndTimer();
	}

	End:

	SavedVariables[Index] = Option;
}