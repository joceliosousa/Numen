@EndUserText.label : 'Draft - Mat. aviao comprado RME X Kit RME'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmekit_d {

  key mandt     : mandt not null;
  key matnr     : matnr not null;
  key omrme     : abap.numc(6) not null;
  key matnrkit  : matnr not null;
  codigoembraer : matnr;
  qtde          : abap.numc(5);
  qtdeorig      : abap.numc(5);
  status        : abap.char(1);
  statustext    : abap.char(3);
  userincl      : abap.char(12);
  dataincl      : abap.dats;
  horaincl      : abap.tims;
  useralt       : abap.char(12);
  dataalt       : abap.dats;
  horaalt       : abap.tims;
  edithidden    : abap_boolean;
  "%admin"      : include sych_bdl_draft_admin_inc;

}
