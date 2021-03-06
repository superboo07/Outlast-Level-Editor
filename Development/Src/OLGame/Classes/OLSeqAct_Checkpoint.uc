/*******************************************************************************
 * OLSeqAct_Checkpoint generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSeqAct_Checkpoint extends SequenceAction
    native
    forcescriptorder(true)
    classgroup(OL,Checkpoint)
    hidecategories(Object);

var() name CheckpointName;
var transient bool bStatusIsOk;

static event int GetObjClassVersion()
{
}

// Export UOLSeqAct_Checkpoint::execGetCheckpointFromName(FFrame&, void* const)
native function OLCheckpoint GetCheckpointFromName(name CPName);

event Activated()
{
}

defaultproperties
{
    InputLinks(0)=(LinkDesc="Save",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks=none
    VariableLinks=none
    ObjName="Checkpoint"
    ObjCategory="Gameplay"
}