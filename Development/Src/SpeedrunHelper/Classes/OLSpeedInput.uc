class OLSpeedInput extends OLPlayerInput;

var PrivateWrite IntPoint MousePosition;

var array<Name> Inputs;

var vector2D Movement;

var vector2D Turning;

event PlayerInput(float DeltaTime)
{
	// Handle mouse
	// Ensure we have a valid HUD
	if (myHUD != None && OLSpeedHud(myHUD).Show_Menu==true)
	{
		// Add the aMouseX to the mouse position and clamp it within the viewport width
		MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX);
		// Add the aMouseY to the mouse position and clamp it within the viewport height
		MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY);
	}

	Movement=Vect2d(aBaseY,aStrafe);

	Super.PlayerInput(DeltaTime);

	Turning=Vect2D(aMouseX, aMouseY);
}

function bool Key( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
	if (ContainsName(Inputs, Key) )
	{
		Inputs.RemoveItem(Key);

		if (OLSpeedHud(HUD).Show_Menu==true) { return true; }
		return false;
	}
	Inputs.additem(Key);
	if (OLSpeedHud(HUD).Show_Menu==true)
	{
		switch (key)
		{
			Case 'LeftMouseButton':
			OLSpeedHud(HUD).Click();
			break;

			case 'Enter':
			OLSpeedHud(HUD).Commit();
			break;

			case 'Backspace':
			OLSpeedHud(HUD).Command = Left(OLSpeedHud(HUD).Command, len(OLSpeedHud(HUD).Command)-1);
			break;

			case 'Tilde':
			ConsoleCommand("OpenConsoleMenu 0");
			break;
		}
		Return true;
	}
	return false;
}

function bool Char( int ControllerId, string Unicode )
{
	local int Character;

	Character = Asc(Left(Unicode, 1));

	if (OLSpeedHud(HUD).Show_Menu==true)
	{
		if (Character >= 0x20 && Character < 0x100 && Unicode!="`")
		{
			OLSpeedHud(HUD).Command = OLSpeedHud(HUD).Command $ Unicode;
		}
		return true;
	}
	return false;
}

Function Bool ContainsName(Array<Name> Array, Name find)
{
	Switch(Array.Find(find))
	{
		case -1:
			Return False;
		break;

		Default:
			Return true;
		Break;
	}
}

defaultproperties
{
	OnReceivedNativeInputKey=Key
	OnReceivedNativeInputChar=Char
}