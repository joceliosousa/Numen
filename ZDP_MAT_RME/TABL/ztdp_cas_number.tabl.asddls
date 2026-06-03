@EndUserText.label : 'ZDPTMM060 Cadastro de CAS Number'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_cas_number {

  key mandt  : abap.clnt not null;
  key codcas : abap.char(12) not null;
  grupo      : zgrupo_cas;
  descas_pt  : abap.char(60);
  descas_en  : abap.char(60);
  uname      : syuname;
  aedat      : abap.dats;
  uptim      : abap.tims;
  status     : zstatus_cas;

}
