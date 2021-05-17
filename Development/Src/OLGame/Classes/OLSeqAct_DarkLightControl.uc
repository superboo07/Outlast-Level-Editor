/*******************************************************************************
 * OLSeqAct_DarkLightControl generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSeqAct_DarkLightControl extends SequenceAction
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var(Outlast) float DarkLightBrightness;
var(Outlast) float DarkLightRadius;

defaultproperties
{
    // Object Offset:0x001F9D1D
    DarkLightBrightness=0.060
    DarkLightRadius=150.0
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks(1)=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="DarkLight Controller"
    ObjCategory="Gameplay"
}