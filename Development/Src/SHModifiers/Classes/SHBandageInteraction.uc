class SHBandageInteraction extends SHModifierInteraction;

var SHBandageFunny BandageModifier;

exec Function Bandage()
{
	BandageModifier.Bandage();
}

exec Function StopBandage()
{
	BandageModifier.StopBandage();
}

event onAttach()
{
    BandageModifier=SHBandageFunny(Outer);
}