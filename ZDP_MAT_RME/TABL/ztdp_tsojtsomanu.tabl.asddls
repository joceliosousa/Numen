@EndUserText.label : 'ZDPTMM048 - DP-011 - Tabela de'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_tsojtsomanu {

  key mandt    : abap.clnt not null;
  key matnr    : matnr not null;
  key omrme    : zomrme not null;
  key certtype : zcerttype not null;
  key certnumb : abap.char(15) not null;
  grupo        : zgrupo;
  dal          : abap.char(30);
  indappro     : abap_boolean;
  status       : abap.char(1);
  userincl     : abap.char(12);
  dataincl     : abap.dats;
  horaincl     : abap.tims;
  useralt      : abap.char(12);
  dataalt      : abap.dats;
  horaalt      : abap.tims;

}
