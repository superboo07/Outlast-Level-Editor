/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class OLGameInfo extends GameInfo;

auto State PendingMatch
{
Begin:
	StartMatch();
}

defaultproperties
{
	HUDType=class'GameFramework.MobileHUD'
	PlayerControllerClass=class'OLGame.OLPlayerController'
	DefaultPawnClass=class'OLGame.OLPawn'
	bDelayedStart=false
}


