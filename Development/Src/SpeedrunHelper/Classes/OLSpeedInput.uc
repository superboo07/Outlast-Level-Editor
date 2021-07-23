class OLSpeedInput extends OLPlayerInput
config(Input);

var PrivateWrite IntPoint MousePosition;

var array<Name> Inputs;
var config array<KeyBind> ControllerBinds;

var config array<KeyBind> BandageBinds;

var vector2D Movement;

var vector2D Turning;

var bool bLeftClick;

var int row, column;

event PlayerInput(float DeltaTime)
{
	// Handle mouse
	// Ensure we have a valid HUD
	if (myHUD != None && OLSpeedHud(myHUD).Show_Menu==true && OLSpeedHud(myHUD).bShouldDrawMouse==true)
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
	local KeyBind Bind;

	if (bGamepad == false && OLSpeedHud(HUD).SelectedButton.row!=-1)
	{
		row = OLSpeedHud(HUD).SelectedButton.row;
		column = OLSpeedHud(HUD).SelectedButton.column;
		OLSpeedHud(HUD).SelectedButton.row=-1;
		OLSpeedHud(HUD).bShouldDrawMouse=true;
	}
	else if (bGamepad == true && OLSpeedHud(HUD).SelectedButton.row==-1)
	{
		OLSpeedHud(HUD).SelectedButton.row=row;
		OLSpeedHud(HUD).SelectedButton.column=column;
		OLSpeedHud(HUD).bShouldDrawMouse=False;
	}

	//if (Key=='LeftMouseButton' && OLSpeedHud(HUD).Show_Menu==true) {Clicking=!Clicking;}
	if (OLSpeedHud(HUD).Show_Menu==true)
	{
		Switch (Event)
		{
			Case IE_Pressed:
				switch (key)
				{
					case 'Enter':
					OLSpeedHud(HUD).Commit();
					break;

					case 'Backspace':
					OLSpeedHud(HUD).Command = Left(OLSpeedHud(HUD).Command, len(OLSpeedHud(HUD).Command)-1);
					break;

					Case 'LeftMouseButton':
					bLeftClick=True;
					break;
				}
			break;

			Case IE_Released:
				switch (key)
				{
					Case 'LeftMouseButton':
					OLSpeedHud(HUD).Click();
					bLeftClick=False;
					break;
				}
				foreach Bindings(Bind)
				{
					if (Bind.Name==Key)
					{
						Switch(Bind.Command)
						{
							Case "SH_Button": Return False;
						}
					}
				}
			break;

			Case IE_Repeat:
				switch (key)
				{
				}
		}
		foreach Bindings(Bind)
		{
			if (Bind.Name==Key)
			{
				Switch(Bind.Command)
				{
					Case "SH_Console":
					bLeftClick=false;
					Return False;
				}
			}
		}
		foreach ControllerBinds(Bind)
		{
			if (bind.name==Key)
			{
				Return False;
			}
		}
		Return true;
	}
	return false;
}

Function BindController(bool Menu)
{
	local array<Keybind> array;

	local keybind bind;
	if (Menu)
	{
		array=ControllerBinds;
	}
	else
	{
		Switch(GamepadConfig)
		{
			Case GBT_A:
			array=GPBindingsA;
			break;

			Case GBT_B:
			array=GPBindingsB;
			break;

			Case GBT_C:
			array=GPBindingsC;
			break;
		}
	}

	Foreach Array(bind)
	{
		SetBind(bind.name, bind.command);
		if (OLSpeedController(HUD.PlayerOwner).bIsOL2BandageSimulatorEnabled)
		{
			ApplyBandageBinds(true);
		}
	}
}

Function ApplyBandageBinds(bool Bandage)
{
	local array<Keybind> DefaultOutlastBinds;
	local int Index;

	local keybind bind, bind2;

	Switch(GamepadConfig)
	{
		Case GBT_A:
		DefaultOutlastBinds=GPBindingsA;
		break;

		Case GBT_B:
		DefaultOutlastBinds=GPBindingsB;
		break;

		Case GBT_C:
		DefaultOutlastBinds=GPBindingsC;
		break;
	}

	if (Bandage)
	{
		Foreach DefaultOutlastBinds(bind)
		{
			Foreach BandageBinds(bind2)
			{
				if (Bind.Command==String(Bind2.Name) )
				{
					SetBind(Bind.Name, Bind2.Command);
				}
			}
		}
	}
	else
	{
		Foreach DefaultOutlastBinds(bind)
		{
			Foreach BandageBinds(bind2)
			{
				if ( Bind.Command==Bind2.Command )
				{
					SetBind(Bind.Name, DefaultOutlastBinds[Index].Command);
				}
			}
			++Index;
		}
	}
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