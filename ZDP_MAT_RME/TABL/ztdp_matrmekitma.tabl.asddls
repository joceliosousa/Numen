@EndUserText.label : 'ZDPTMM021 - Material avião comprado RME X Kit RME (manut.)'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table ztdp_matrmekitma {

  key mandt    : abap.clnt not null;
  key matnr    : matnr not null;
  key omrme    : abap.numc(6) not null;
  key matnrkit : matnr not null;
  qtde         : abap.numc(5);
  qtde_orig    : abap.numc(5);
  status       : abap.char(1);
  userincl     : abap.char(12);
  dataincl     : abap.dats;
  horaincl     : abap.tims;
  useralt      : abap.char(12);
  dataalt      : abap.dats;
  horaalt      : abap.tims;

}
