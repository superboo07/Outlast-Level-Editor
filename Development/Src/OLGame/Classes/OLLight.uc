/*******************************************************************************
 * OLLight generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLLight extends Actor
    placeable
    hidecategories(Navigation)
    classgroup(OL,Ingredient);

var() export editinline StaticMeshComponent LightMesh;
var() export editinline StaticMeshComponent FogMesh;
var() export editinline SpotLightComponent SpotLight;

defaultproperties
{
    begin object name=Mesh0 class=StaticMeshComponent
        StaticMesh=StaticMesh'Lights.Ceilling.Neon_light'
        Materials=/* Array type was not detected. */
        ReplacementPrimitive=none
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
    End Object
    // Reference: StaticMeshComponent'Default__OLLight.Mesh0'
    LightMesh=Mesh0
    begin object name=Mesh1 class=StaticMeshComponent
        StaticMesh=StaticMesh'Asylum_effect.Fog.Light_fog'
        ReplacementPrimitive=none
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
        CollideActors=false
        BlockActors=false
        LightingChannels=(bInitialized=true,Static=true)
    End Object
    // Reference: StaticMeshComponent'Default__OLLight.Mesh1'
    FogMesh=Mesh1
    begin object name=CeilingLight class=SpotLightComponent
        OuterConeAngle=50.0
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        Translation=(X=0.0,Y=0.0,Z=-10.0)
        LightColor=(R=223,G=236,B=255,A=0)
        CastDynamicShadows=false
        LightingChannels=(Dynamic=false)
        LightAffectsClassification=ELightAffectsClassification.LAC_STATIC_AFFECTING
    End Object
    // Reference: SpotLightComponent'Default__OLLight.CeilingLight'
    SpotLight=CeilingLight
    // Reference: StaticMeshComponent'Default__OLLight.Mesh0'
    Components(0)=Mesh0
    // Reference: StaticMeshComponent'Default__OLLight.Mesh1'
    Components(1)=Mesh1
    // Reference: SpotLightComponent'Default__OLLight.CeilingLight'
    Components(2)=CeilingLight
    CollisionType=ECollisionType.COLLIDE_NoCollision
    bStatic=true
    bMovable=false
}