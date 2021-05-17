/*******************************************************************************
 * OLSeqAct_SetNanoCloudVisibility generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSeqAct_SetNanoCloudVisibility extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float AlwaysVisibleDistance;
var() float FullOpacityDistance;
var() float DistanceBasedVisibilityMorphTimeScale;

defaultproperties
{
    // Object Offset:0x00203A38
    AlwaysVisibleDistance=500.0
    DistanceBasedVisibilityMorphTimeScale=12.0
    InputLinks(0)=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set NanoCloud Visibility"
}