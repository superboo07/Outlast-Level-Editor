/*******************************************************************************
 * OLSeqAct_Fade generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLSeqAct_Fade extends SequenceAction
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var() bool bFadeIn;
var() bool bForceStartValue;
var() float Opacity;
var() Color FadeColor;
var() float Duration;

defaultproperties
{
    // Object Offset:0x001FCAD4
    bFadeIn=true
    Opacity=1.0
    Duration=2.0
    VariableLinks=none
    ObjName="Fade"
    ObjCategory="Gameplay"
}