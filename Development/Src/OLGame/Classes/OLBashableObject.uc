/*******************************************************************************
 * OLBashableObject generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLBashableObject extends Actor
    native
    placeable
    hidecategories(Navigation)
    classgroup(OL,Ingredient);

enum EOLBashableType
{
    EOLBT_Wall,
    EOLBT_Table,
    EOLBT_MAX
};

var() OLBashableObject.EOLBashableType BashableType;
var() export editinline StaticMeshComponent PreBashCollision;
var() export editinline StaticMeshComponent PostBashCollision;
var() export editinline SkeletalMeshComponent Mesh;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() name BashAnimation;
var() float PathPointOffset;
var() float BashYOffset;
var() bool bEnabled;
var bool bBroken;
var transient bool bInitiallyEnabled;
var Vector Edge0Dest;
var Vector Edge1Dest;

function Break()
{
}

function TriggerBreakTimer(float Time)
{
}

function ClearBreakTimer()
{
}

function OnToggle(SeqAct_Toggle Action)
{
}

defaultproperties
{
}