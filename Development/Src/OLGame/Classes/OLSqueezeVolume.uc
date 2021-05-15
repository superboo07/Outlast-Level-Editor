/*******************************************************************************
 * OLSqueezeVolume generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSqueezeVolume extends OLGameplayVolume
    native
    hidecategories(Navigation,Object,Movement,Display);

var() OLGameplayMarker Node1;
var() OLGameplayMarker Node2;
var() bool bCanLookLeft;
var() bool bCanLookRight;
var() bool bNoHands;

simulated event PostBeginPlay()
{
}

defaultproperties
{
    bCanLookLeft=true
    bCanLookRight=true
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    // Reference: BrushComponent'Default__OLSqueezeVolume.BrushComponent0'
    BrushComponent=BrushComponent0
    // Reference: BrushComponent'Default__OLSqueezeVolume.BrushComponent0'
    Components(0)=BrushComponent0
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    // Reference: BrushComponent'Default__OLSqueezeVolume.BrushComponent0'
    CollisionComponent=BrushComponent0
}