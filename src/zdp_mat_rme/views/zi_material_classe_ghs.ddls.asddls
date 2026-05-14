@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Classe GHS / Material'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MATERIAL_CLASSE_GHS
  as select from ztdp_mat_cl_ghs
{
  key matnr   as Material,
  key omrme   as Omrme,
      cod_ghs as CodGHS
}
