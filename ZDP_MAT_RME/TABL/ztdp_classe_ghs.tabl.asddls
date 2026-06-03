@EndUserText.label : 'ZDPTMM054 - Tabela de Classe GHS'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztdp_classe_ghs {

  @EndUserText.label : 'Mandante'
  key mandt   : abap.clnt not null;
  @EndUserText.label : 'Classe GHS'
  key cod_ghs : abap.char(4) not null;
  @EndUserText.label : 'Linha de texto'
  dsc_per_pt  : abap.char(132);
  @EndUserText.label : 'Linha de texto'
  dsc_per_en  : abap.char(132);
  @EndUserText.label : 'Palavra de Advertência'
  pal_adv_pt  : abap.char(40);
  @EndUserText.label : 'Palavra de Advertência'
  pal_adv_en  : abap.char(40);
  @EndUserText.label : 'Pictograma'
  img_picto   : abap.char(10);

}
