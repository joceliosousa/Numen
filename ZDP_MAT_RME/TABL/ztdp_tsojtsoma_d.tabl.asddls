@EndUserText.label : ''
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_tsojtsoma_d {

  key mandt      : mandt not null;
  key matnr      : matnr not null;
  key omrme      : zomrme not null;
  key certtype   : zcerttype not null;
  key certnumber : abap.char(15) not null;
  grupo          : zgrupo;
  dal            : abap.char(30);
  indapprovacao  : abap_boolean;
  status         : abap.char(1);
  userincl       : abap.char(12);
  dataincl       : abap.dats;
  horaincl       : abap.tims;
  useralt        : abap.char(12);
  dataalt        : abap.dats;
  horaalt        : abap.tims;
  "%admin"       : include sych_bdl_draft_admin_inc;

}
