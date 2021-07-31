class SHFreeBhops extends SHModifier;

Event bool onEnable()
{
    Hero.onLanded=Landed;
    return true;
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    Hero.TakeFallingDamage();
}

Event onDisable()
{
    Hero.onLanded=None;
}