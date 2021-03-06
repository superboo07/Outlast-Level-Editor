/*******************************************************************************
 * ActorFactoryOLAI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class ActorFactoryOLAI extends ActorFactoryAI
	dependsOn(OLEnemyPawn)
    native(AI)
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native ShaderValues
{
    var bool bOverride_UniformColor;
    var() LinearColor UniformColor;

    structdefaultproperties
    {
        bOverride_UniformColor=false
        UniformColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    }
};

var() OLBTBehaviorTree BehaviorTree;
var() SkeletalMesh MeshOverride;
var() ShaderValues ShaderOverrides;
var const name UniformColorName;
var() bool bOverrideLightingFlags;
var() bool bCastStaticShadow;
var() bool bCastDynamicShadow;
var() bool bSelfShadowOnly;
var() bool bCastShadowInNightVision;
var() bool bPlaySpawnWaypointAnim;
var deprecated bool ShouldAttack;
var deprecated bool bUseKillingBlow;
var deprecated bool bAlwaysLookAtPlayer;
var() EnemyModifiers PawnModifiers;
var() array<AnimSet> AdditionalAnimSets;
var() OLAIContextualVOAsset VOAsset;

defaultproperties
{
    ShaderOverrides=(bOverride_UniformColor=false,UniformColor=(R=0.0,G=0.0,B=0.0,A=1.0))
    UniformColorName=uniform_color
    PawnModifiers=(bShouldAttack=false,bUseKillingBlow=false,bAlwaysLookAtPlayer=false,bDisableRepulsion=false,bSpawnWithNavMeshObstacle=false,bUseForMusic=false,bForceUseForStressBreath=false,bDisableKnockbackFromPlayer=false,bUseGroup=true,WeaponToUse=EWeapon.Weapon_None,bInterruptVOOnChase=true,bAttackOnProximity=false)
    ControllerClass=class'OLBot'
    PawnClass=class'OLEnemyPawn'
}