class TasPlayerInput extends OLPlayerInput within TasPlayerController;

var config array<KeyBind> ControllerBinds, BandageBinds, ControllerDebugBinds;

var bool bUseGamepadLastTick, bLeftClick, bWantsToSimulateController;
var PrivateWrite IntPoint MousePosition;
var array<Name> Inputs;
var vector2D Movement, Turning;
var int row, column;

var float lastMouseX, lastMouseY, SavedDeltaTime;

var bool bIsForward, bIsBack;

var TasInputSaver TASInput;

// aBaseY
// aStrafe
// aTurn
// aLookUp
event PlayerInput(float DeltaTime)
{
	SavedDeltaTime=DeltaTime;
	// Handle mouse
	// Ensure we have a valid HUD
	if (myHUD != None && !UsingGamepad() )
	{
		// Add the aMouseX to the mouse position and clamp it within the viewport width
		MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX);
		// Add the aMouseY to the mouse position and clamp it within the viewport height
		MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY);
	}

	bUseGamepadLastTick=UsingGamepad();

	Super.PlayerInput(DeltaTime);
	//bWantsToSimulateController = SHHUD(HUD).GetSHDebugOption( 'SimulateController' );
	Turning=Vect2D(aMouseX, aMouseY);
	Movement=Vect2d(aBaseY,aStrafe);

	if (TASInput==None)
	{
		`log("Tas Input is Invalid");
		TASInput=Spawn(Class'TAS.TasInputSaver');
		TasInput.Input=Self;
		TasInput.Hero=Outer.HeroPawn;
		TasInput.CurrentGame=TasGame(WorldInfo.Game);
	}
}

event Tick(float DeltaTime)
{
	local int InputIndex;
	if(TASInput != None)
	{
		if(TASInput.IsPlayback == true)
		{
			InputIndex = TASInput.CurrentPlaybackInputIndex;
			if(InputIndex < TASInput.MaxPlaybackInputs)
			{
				`log("Checking input " $ InputIndex $ ". Time: " $ TASInput.PlaybackTime);
				if(TASInput.Recording.Inputs[InputIndex].Time <= TASInput.PlaybackTime)
				{
					`log("Executing input " $ InputIndex);
					//ConsoleCommand(FindCommandFromBind(TASInput.Recording.Inputs[InputIndex].KeyPress));
					ExecuteCustomBinding(TASInput.Recording.Inputs[InputIndex].KeyPress.Name, TASInput.Recording.Inputs[InputIndex].InputEvent, Bindings);
					TASInput.CurrentPlaybackInputIndex++;
					`log("Input index: " $ (InputIndex++));
				}
				if (bIsForward) {aBaseY=1;}
			}
			if(DeltaTime > 0)
				TASInput.PlaybackTime += DeltaTime;
		}
	}
}

function bool Key(int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE)
{
	local KeyBind Bind;
	local KeyBind KeyPress;
	local Array<keybind> SavedBindings;

	if(TASInput.bIsRecording == true)
	{
		KeyPress = GetKeyBindFromKey(Key);
		if(!(KeyPress.Command == "StartRecord" || KeyPress.Command == "StopRecord" || KeyPress.Command == "LogRecording"))
		{
			TASInput.RecordInput(GetKeyBindFromKey(Key), Event, false);
		}
	}

	return false;

}

exec function StartRecord()
{
	TASInput.StartRecording();
}

exec function StopRecord()
{
	TASInput.StopRecording();
}

exec function StartPlaying()
{
	TASInput.StartPlayback();
}

exec function StopPlaying()
{
	TASInput.StopPlayback();
}

exec function LogRecording()
{
	TASInput.LogRecording();
}

function Array<Keybind> PatchBindingArray(Array<Keybind> Target, Array<Keybind> Patcher)
{
	local array<Keybind> DefaultOutlastBinds;
	local int Index;

	local keybind bind, bind2, bind3;

	Foreach Target(bind)
	{
		Foreach Patcher(bind2)
		{
			if (Bind.Command==String(Bind2.Name) )
			{
				bind3.Name=Bind.name;
				bind3.Command=Bind2.Command;
				DefaultOutlastBinds.AddItem(bind3);
			}
		}
	}
	return DefaultOutlastBinds;
}

function bool Char( int ControllerId, string Unicode )
{
	local int Character;

	Character = Asc(Left(Unicode, 1));

	/*if (SHHud(HUD).Show_Menu==true)
	{
		if (Character >= 0x20 && Character < 0x100 && Unicode!="`")
		{
			SHHud(HUD).Command = SHHud(HUD).Command $ Unicode;
		}
		return true;
	}*/
	return false;
}

function bool ContainsName(Array<Name> Array, Name find)
{
	Switch(Array.Find(find))
	{
		case -1:
			return False;
		break;

		Default:
			return true;
		Break;
	}
}

function Array<Keybind> GetControllerBind()
{
	Switch(GamepadConfig)
	{
		Case GBT_A:
		return GPBindingsA;
		break;

		Case GBT_B:
		return GPBindingsB;
		break;

		Case GBT_C:
		return GPBindingsC;
		break;
	}
}

function PreProcessInput(float DeltaTime)
{
    super(PlayerInput).PreProcessInput(DeltaTime);
    RawJoyLookRight = aMouseX;
    RawJoyLookUp = aMouseY;
}

function string FindCommandFromBind(keybind Bind)
{
	
	local int index;

	
	CheckAgain: //Run while it can find a bind with the command as it's name
	index = Bindings.Find('Name', Name(Bind.Command) );
	if (Index!=Index_None) 
	{
		Bind=Bindings[index];
		goto CheckAgain;
	}
	return Bind.Command;
}

function bool ExecuteCustomBinding(Name Key, EInputEvent Event, Array<Keybind> Keybinds)
{
	local keybind bind;
	local string KeyBind;
	foreach Keybinds(Bind)
	{
		if (Bind.Name == Key)
		{
			KeyBind = FindCommandWithExternalBinding(Bind, Event, Keybinds);
			switch(Event)
			{
				case IE_Pressed:
					switch(KeyBind)
					{
						case "Axis aBaseY Speed=1.0":
							bIsForward=true;
					}
				break;
				
				case IE_Released:
					switch(KeyBind)
					{
						case "Axis aBaseY Speed=1.0":
							bIsForward=false;
					}
				break;
			}
			ConsoleCommand( KeyBind ); //Execute the final command as an console command
			aBaseY=1;
			//Const variables can't be set directly by unrealscript, but using the console command function to set them using the set command still works.
			return True;
		}
	}
	return False;
}

function string FindCommandWithExternalBinding(keybind Bind, EInputEvent InputEvent, array<keybind> Binds)
{
	local int index;
	local bool bEscapedExternalBinding;
	local array<string> StringArray;

	
	CheckAgain: //Run while it can find a bind with the command as it's name
	index = Binds.Find('Name', Name(Bind.Command) );
	if (Index!=Index_None) 
	{
		Bind=Binds[index];
		goto CheckAgain;
	}
	if (!bEscapedExternalBinding) //Check the OG binds list since the plugged in list has been starved
	{
		bEscapedExternalBinding=true;
		Binds=Bindings;
		goto CheckAgain;
	}
	index = InStr(Bind.Command, " | onrelease ");
	if (index==Index_None)
	{
		if (InputEvent==IE_Pressed) {return Bind.Command;} //return command once
		else {return "";} //return nothing if the input event is not caused by pressing down the button.
	}
	else
	{
		StringArray = SplitString(Bind.Command, " | onrelease ", true); //Split the string between the onRelease command.
		Switch (InputEvent)
		{
			Case IE_Pressed:
			Bind.Command = StringArray[0]; //return the onPressed command
			break;

			Case IE_Released:
			Bind.Command = StringArray[1]; //return the onReleased command
			break;

			Default: return "";
		}
	}
	return Bind.Command;
}

function KeyBind GetKeyBindFromKey(name Key)
{
	local int Index;
	local keybind dummy; //Use this to return an empty bind, make sure to check if the bind is empty before saving to the array.

	Index = Bindings.Find('Name', Key);

	if (Index<=Index_None)
	{
		return dummy;
	}

	return Bindings[Index];
}

function bool UsedGamepadLastTick()
{
	return bUseGamepadLastTick;
}

function bool UsingGamepad()
{
	return bUsingGamepad || bWantsToSimulateController;
}

defaultproperties
{
	OnReceivedNativeInputKey=Key
	OnReceivedNativeInputChar=Char
	StrafeCommand="Axis aStrafe Speed=1.0 DeadZone=0.3"
    MoveCommand="Axis aBaseY Speed=1.0 DeadZone=0.3"
    LookXCommand="Axis aMouseX Speed=15.0 DeadZone=0.2"
    LookYCommand="Axis aMouseY Speed=-12.0 DeadZone=0.2"
    SouthpawMoveCommand="Axis aBaseY Speed=-1.0 DeadZone=0.3"
    SouthpawLookYCommand="Axis aMouseY Speed=12.0 DeadZone=0.2"
	Inputs = ("W", "A", "S", "D", "LeftShift", "SpaceBar", "Control", "M", "L")
	// Inputs.AddItem("LeftShift");
	// Inputs.AddItem("SpaceBar");
	// Inputs.AddItem("Control");
	// Inputs.AddItem("Tab");
	TasInput=Default__TasInputSaver
}