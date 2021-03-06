/*******************************************************************************
 * OLPickableObject generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLPickableObject extends Actor
    abstract
    native
    notplaceable
    classgroup(OL,Pickups)
    hidecategories(Navigation);

var() export editinline StaticMeshComponent PickupMesh;
var() export editinline DynamicLightEnvironmentComponent PickupLightEnvironment;
var() export editinline StaticMeshComponent EditorMesh;
var bool bUsed;
var bool bPickupOnNotify;
var transient bool bDisabled;
var() Vector AttachPositionOffset;
var() Rotator AttachRotationOffset;

simulated function OnToggle(SeqAct_Toggle Action)
{
}

defaultproperties
{
    begin object name=PickupMeshComp class=StaticMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__OLPickableObject.LightEnvironmentComp'
        CastShadow=false
        bCastDynamicShadow=false
    end object
    PickupMesh=PickupMeshComp
    PickupLightEnvironment=DynamicLightEnvironmentComponent'Default__OLPickableObject.LightEnvironmentComp'
    bPickupOnNotify=true
    Components(0)=DynamicLightEnvironmentComponent'Default__OLPickableObject.LightEnvironmentComp'
    Components(1)=PickupMeshComp
    Components(2)=CollisionCylinder
    bAlwaysRelevant=true
    bEdShouldSnap=true
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */

    begin object name=EditorMeshComp class=StaticMeshComponent
		HiddenEditor=False
    End Object
    EditorMesh=EditorMeshComp
    Components.add(EditorMeshComp)
}