Class SHModDebug extends SHModifier;

Event onDrawHUD(SHHUD Caller)
{
    local string PlayerDebug;
	PlayerDebug=PlayerDebug $ "\n\nCanvas Debug: \nCurrent AspectRatio: " $ Caller.GetAspectRatio() $ "\nWidth: " $ Caller.Canvas.SizeX $ "\nHeight: " $ Caller.Canvas.SizeY;
	PlayerDebug=PlayerDebug $ "\n\nMenu Debug: \nCurrently Selected Row: " $ Caller.SelectedButton.Row $ "\nCurrently Selected Column: " $ Caller.SelectedButton.Column;
	PlayerDebug=PlayerDebug $ "\nPrevious Controller Interaction: " $ Caller.DebugPreviousMove;
	if (Caller.Controller.bIsOL2StaminaSimulatorEnabled)
	{
		PlayerDebug=PlayerDebug $ "\n\nStamina Debug: " $ "\nCurrent Stamina: " $ Caller.SpeedPawn.RunStamina $ "\nStamina Percent: " $ Caller.SpeedPawn.StaminaPercent $ "\nOut of Stamina: " $ Caller.SpeedPawn.bOutofStamina;
		PlayerDebug=PlayerDebug $ "\nCurrent Stamina State: " $ Caller.SpeedPawn.CurrentStaminaState $ "\nReady to sprint: " $ Caller.SpeedPawn.bReadytosprint;
	}

	if (Caller.Controller.bIsOL2BandageSimulatorEnabled)
	{
		PlayerDebug=PlayerDebug $ "\n\nBandageDebug: " $ "\nbNeedsBandage: " $ Caller.SpeedPawn.bNeedsBandage $ "\nIsBandaging: " $ Caller.SpeedPawn.bIsBandaging $ "\nWearing Bandage: " $ Caller.SpeedPawn.bHasBandage;
		PlayerDebug=PlayerDebug $ "\nSpeedPercent: " $ Caller.SpeedPawn.SpeedPercent;
	}

    Caller.PlayerDebug = Caller.PlayerDebug $ PlayerDebug;
}
