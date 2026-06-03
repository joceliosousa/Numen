@EndUserText.label : 'ZDPTMM003 - Classificação RME.'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_rme {

  key client       : abap.clnt not null;
  key num_cap_rme  : abap.char(2) not null;
  key num_sucp_rme : abap.char(2) not null;
  key num_scao_rme : abap.char(3) not null;
  descricaopt      : abap.char(65);
  descricaoen      : abap.char(65);
  catmat           : abap.char(1);
  clasferr         : abap.char(3);
  meins            : abap.unit(3);
  @Semantics.quantity.unitOfMeasure : 'ztdp_rme.meins'
  qtde_min         : abap.quan(13,3);
  @Semantics.quantity.unitOfMeasure : 'ztdp_rme.meins'
  qtde_max         : abap.quan(13,3);
  indic_perig      : abap.char(2);
  relev_prox_mont  : abap.char(1);
  created_by       : abp_creation_user;
  created_at       : abp_creation_tstmpl;
  changed_by       : abp_lastchange_user;
  changed_at       : abp_lastchange_tstmpl;

}
