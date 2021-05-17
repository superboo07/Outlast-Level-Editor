/*******************************************************************************
 * OLSeqEvent_SpawnedAtCheckpoint generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSeqEvent_SpawnedAtCheckpoint extends SequenceEvent
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var() name CheckpointName;
var transient bool bStatusIsOk;

defaultproperties
{
    VariableLinks=none
    ObjName="SpawnedAtCheckpoint"
    ObjCategory="Gameplay"
}