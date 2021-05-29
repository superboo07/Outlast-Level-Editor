/*******************************************************************************
 * OLUtils generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUtils extends Object
    native;

// Export UOLUtils::execIsPS4(FFrame&, void* const)
native static function bool IsPS4();

// Export UOLUtils::execIsConsole(FFrame&, void* const)
native static function bool IsConsole();

// Export UOLUtils::execIsDLCInstalled(FFrame&, void* const)
native static function bool IsDLCInstalled();

// Export UOLUtils::execIsPlayingDLC(FFrame&, void* const)
native static function bool IsPlayingDLC();

// Export UOLUtils::execIsBindableKey(FFrame&, void* const)
native static function bool IsBindableKey(name ButtonName);

// Export UOLUtils::execGetOLPC(FFrame&, void* const)
native static function OLPlayerController GetOLPC();