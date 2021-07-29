Class DUGame extends OLGame;

//Override SetGameType so it returns the Gameinfo in the class
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal) 
{
    return Default.class;
}

Event Tick(Float DeltaTime)
{
    local OLDoor Door; //Store Door here

	foreach allactors(class'OLDoor', Door) //Fetch every door class.
	{
		Door.bLocked=false; //Unlock the door
		Door.bBlocked=false; //Allow opening the door even if it is technically blocked
	}

	Super.Tick(DeltaTime); //I don't know if it matters, but just in case run the parent tick to ensure nothing gets broken.
}