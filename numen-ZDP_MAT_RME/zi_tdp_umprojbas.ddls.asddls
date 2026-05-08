@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZDPTMM038 - Unidades de Medida (CDS)'
define view entity ZI_TDP_UMPROJBAS
  as select from ztdp_umprojbas
{
  key ausme as Ausme,
      meins as Meins
}
