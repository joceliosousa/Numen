@EndUserText.label : 'ZDPTMM038 - Tabela de Unidades de Medidas'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_umprojbas {

  key mandt : abap.clnt not null;
  key ausme : abap.char(3) not null;
  meins     : meins;

}
