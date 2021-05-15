/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class TEMPLATE_SHORT_NAMEGameInfo extends GameInfo;

auto State PendingMatch
{
Begin:
	StartMatch();
}

defaultproperties
{
	HUDType=class'GameFramework.MobileHUD'
	PlayerControllerClass=class'TEMPLATE_SHORT_NAMEGame.TEMPLATE_SHORT_NAMEPlayerController'
	DefaultPawnClass=class'TEMPLATE_SHORT_NAMEGame.TEMPLATE_SHORT_NAMEPawn'
	bDelayedStart=false
}


