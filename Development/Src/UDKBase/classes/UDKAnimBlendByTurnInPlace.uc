/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class UDKAnimBlendByTurnInPlace extends UDKAnimBlendBase
	native(Animation);

var() float	RootYawSpeedThresh;
var() float TurnInPlaceBlendSpeed;
var const transient UDKPawn OwnerUTP;

cpptext
{
	// AnimNode interface
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual	void TickAnim(FLOAT DeltaSeconds);
}

defaultproperties
{
	Children(0)=(Name="Idle",Weight=1.0)
	Children(1)=(Name="TurnInPlace")
	bFixNumChildren=true
}
