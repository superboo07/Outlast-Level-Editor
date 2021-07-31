class SHGodMode extends SHModifier;

event bool onEnable()
{
    Hero.onTakeDamage=TakeDamage;
    return true;
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
}

event onDisable()
{
    Hero.onTakeDamage=None;
}