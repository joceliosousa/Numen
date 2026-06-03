@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Tipo Aenv'
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_PLTF_VH
  as select from ztdp_pltf
{
      @EndUserText.label: 'Tipo Aenv'
  key cod_proj_aenv as COD_PROJ_AENV,

      @EndUserText.label: 'Descrição'
      dscpltf       as DSCPLTF
}
where
  indrme = 'X'
