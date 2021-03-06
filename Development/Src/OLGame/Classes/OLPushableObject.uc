/*******************************************************************************
 * OLPushableObject generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLPushableObject extends Actor
    native
    placeable
    hidecategories(Navigation)
    classgroup(OL,Ingredient)
    implements(Interface_NavMeshPathObstacle);

enum PushableMaterial
{
    PM_Wood,
    PM_Metal,
    PM_MAX
};

enum PushableEventType
{
    PET_StartedPushing,
    PET_StoppedPushing,
    PET_UnblockedDoor,
    PET_BlockedDoor,
    PET_MAX
};

var() bool bEnabled;
var() bool bCanPushBack;
var() bool bCanPushFwd;
var() float Width;
var() float MaxBackDist;
var() float MaxFwdDist;
var() OLDoor LinkedDoor;
var() float MaxSpeed;
var() float BaseTranslation;
// var() OLPushableObject.PushableMaterial PushableType;
var() export editinline StaticMeshComponent Mesh;

simulated function OnToggle(SeqAct_Toggle Action)
{
}

defaultproperties
{
    bEnabled=true
    bCanPushBack=true
    bCanPushFwd=true
    Width=136.0
    MaxFwdDist=100.0
    MaxSpeed=30.0
    BaseTranslation=68.0
    // PushableType=PushableMaterial.PM_Metal
	bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
	begin object name=MeshComp class=StaticMeshComponent
        StaticMesh=StaticMesh'OLEditorResources.EditorMeshes.PushableShelf'
        ReplacementPrimitive=none
        bUsePrecomputedShadows=true
        LightingChannels=(Static=true,Dynamic=true)
    End Object
	Components.add(MeshComp)
	Mesh=MeshComp
}