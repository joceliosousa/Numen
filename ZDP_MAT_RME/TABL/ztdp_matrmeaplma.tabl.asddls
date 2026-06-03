@EndUserText.label : 'Aplicabilidade Material RME'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmeaplma {

  @EndUserText.label : 'Mandante'
  key client        : abap.clnt not null;
  key matnr         : matnr not null;
  key omrme         : zomrme not null;
  @EndUserText.label : 'Código de Tipo'
  key cod_proj_aenv : abap.char(4) not null;
  @EndUserText.label : 'Tipo de documento'
  key doctype       : abap.char(5) not null;
  @EndUserText.label : 'Número do Documento'
  key docnro        : abap.char(15) not null;
  @EndUserText.label : 'Status'
  status            : abap.char(1);
  @EndUserText.label : 'Código de Tipo'
  codpltf_orig      : abap.char(4);
  @EndUserText.label : 'Nome do usuário'
  userincl          : abap.char(12);
  @EndUserText.label : 'Data de criação'
  dataincl          : abap.dats;
  @EndUserText.label : 'Hora da criação do registro'
  horaincl          : abap.tims;
  @EndUserText.label : 'Nome do usuário'
  useralt           : abap.char(12);
  @EndUserText.label : 'Data da última modificação'
  dataalt           : abap.dats;
  @EndUserText.label : 'Hora da última modificação'
  horaalt           : abap.tims;

}
