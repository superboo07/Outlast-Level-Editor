/*******************************************************************************
 * OLRecordingMarker generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLRecordingMarker extends OLGameplayMarker
    native
    placeable
    hidecategories(Navigation);

var() float Radius;
var() name MomentName;
var() float MinRecordingDuration;
var() bool bAllowNonContinuousRecording;
var transient bool bRecorded;
var transient bool bRecording;
var() float NotificationDelay;
var transient float StartedRecordingTime;
var transient float AccumulatedRecordingTime;
var export editinline DrawSphereComponent PreviewComp;

defaultproperties
{
    Radius=100.0
    MinRecordingDuration=0.750
    begin object name=SphereComp class=DrawSphereComponent
        ReplacementPrimitive=none
    End Object
    // Reference: DrawSphereComponent'Default__OLRecordingMarker.SphereComp'
    PreviewComp=SphereComp
    Components(0)=none
    Components(1)=SphereComp
	Begin Object Name=Sprite44
        Sprite=Texture2D'OLEditorResources.EditorSprites.OLRecordingMarker_Sprite'
		Scale=.05
    End Object
	Components.Add(Sprite44)
}