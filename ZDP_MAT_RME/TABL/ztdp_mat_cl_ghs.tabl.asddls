@EndUserText.label : 'ZDPTMM057 - Tabela de Materiais'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_mat_cl_ghs {

  @EndUserText.label : 'Mandante'
  key client  : abap.clnt not null;
  key matnr   : matnr not null;
  key omrme   : zomrme not null;
  key cod_ghs : abap.char(4) not null;

}
