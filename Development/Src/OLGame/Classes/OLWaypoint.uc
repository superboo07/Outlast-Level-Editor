/*******************************************************************************
 * OLWaypoint generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
 
class OLWaypoint extends NavigationPoint
    native(AI)
    hidecategories(Navigation,Lighting,LightColor,Force)
    classgroup(OL,AI)
	placeable;

var() float WaitTime;
var() name AnimToPlay;
var() bool bLoopAnimation;
var() bool bTurnToRotation;
var() bool bAlignAnimToWaypoint;

// Export UOLWaypoint::execWaypointReachedEvent(FFrame&, void* const)
native function WaypointReachedEvent(Actor InInstigator);

// Export UOLWaypoint::execAnimStartedEvent(FFrame&, void* const)
native function AnimStartedEvent(Actor InInstigator);

defaultproperties
{
    begin object name=CollisionCylinder 
    end object
    // Reference: CylinderComponent'Default__OLWaypoint.CollisionCylinder'
    CylinderComponent=CollisionCylinder
    Components(3)=CollisionCylinder
    CollisionComponent=CollisionCylinder
	Begin Object Class=SpriteComponent Name=Sprite44
        Sprite=Texture2D'EditorResources.Crowd.T_Crowd_Destination'
        HiddenGame=true
        HiddenEditor=false
        SpriteCategoryName="GSD"
        Scale=.25
    End Object
	Components.Add(Sprite44)
}