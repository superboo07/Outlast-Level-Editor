Class SHWernikieSkip extends SHModifier;

var config Array<Name> WernikieSkipCheckpoints;

Event onDisable()
{
    local OLGame CurrentGame;
    local SkeletalMeshActor SkeletalMesh;
    CurrentGame = OLGame(WorldInfo.Game);

    foreach allactors(Class'SkeletalMeshActor', SkeletalMesh)
	{
		if (String(SkeletalMesh.SkeletalMeshComponent.SkeletalMesh)=="LadCellDoor-01" )
		{
			SkeletalMesh.ReattachComponent(SkeletalMesh.SkeletalMeshComponent);
		}
	}
}

Event onTimer()
{
    local SkeletalMeshActor SkeletalMesh;
	local OLGame CurrentGame;

	CurrentGame = OLGame(WorldInfo.Game);

	foreach allactors(Class'SkeletalMeshActor', SkeletalMesh)
	{
		if (String(SkeletalMesh.SkeletalMeshComponent.SkeletalMesh)=="LadCellDoor-01" )
		{
			if ( WernikieSkipCheckpoints.find(CurrentGame.CurrentCheckpointName)!=Index_None)
			{
				SkeletalMesh.DetachComponent(SkeletalMesh.SkeletalMeshComponent);
			}
			else
			{
				SkeletalMesh.ReattachComponent(SkeletalMesh.SkeletalMeshComponent);
			}
		}
	}
}