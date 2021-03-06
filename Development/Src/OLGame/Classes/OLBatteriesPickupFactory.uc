/*******************************************************************************
 * OLBatteriesPickupFactory generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLBatteriesPickupFactory extends OLPickableObject
    native
    placeable
    hidecategories(Navigation);

var() int NumBatteries;

defaultproperties
{
    // Object Offset:0x001A246F
    NumBatteries=1
    Mesh1=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-01'
    Mesh2=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-02'
    Mesh3=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-03'
    Mesh4=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-04'

    begin object name=PickupMeshComp
        // Object Offset:0x03CB753E
        StaticMesh=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-01'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__OLBatteriesPickupFactory.LightEnvironmentComp'
    End Object
    // Reference: StaticMeshComponent'Default__OLBatteriesPickupFactory.PickupMeshComp'
    PickupMesh=PickupMeshComp
    PickupLightEnvironment=DynamicLightEnvironmentComponent'Default__OLBatteriesPickupFactory.LightEnvironmentComp'
    Components(0)=DynamicLightEnvironmentComponent'Default__OLBatteriesPickupFactory.LightEnvironmentComp'
    // Reference: StaticMeshComponent'Default__OLBatteriesPickupFactory.PickupMeshComp'
    Components(1)=PickupMeshComp
    begin object name=CollisionCylinder class=CylinderComponent
        // Object Offset:0x03457673
        ReplacementPrimitive=none
    End Object
    // Reference: CylinderComponent'Default__OLBatteriesPickupFactory.CollisionCylinder'
    Components(2)=CollisionCylinder
    // Reference: CylinderComponent'Default__OLBatteriesPickupFactory.CollisionCylinder'
    CollisionComponent=CollisionCylinder

    begin object name=EditorMeshComp
        StaticMesh=StaticMesh'OLEditorResources.EditorMeshes.Battery_Dummy'
        bUsePrecomputedShadows=true
		HiddenEditor=False
    End Object
    Components.add(EditorMeshComp)
}
