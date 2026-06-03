@EndUserText.label : ''
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmectd_d {

  key mandt         : mandt not null;
  key matnr         : matnr not null;
  key omrme         : zomrme not null;
  key expsecurity   : abap.char(4) not null;
  key exportlicense : abap.char(10) not null;
  uname             : abap.char(12);
  aedat             : abap.dats;
  uptim             : abap.tims;
  status            : abap.char(1);
  statustext        : abap.char(3);
  licensenumber     : abap.char(9);
  "%admin"          : include sych_bdl_draft_admin_inc;

}
