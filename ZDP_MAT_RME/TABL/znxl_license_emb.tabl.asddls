@EndUserText.label : 'Licencas Embraer NextLabs'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table znxl_license_emb {

  key mandt    : abap.clnt not null;
  key expsec   : abap.char(4) not null;
  key licenses : abap.char(10) not null;

}
