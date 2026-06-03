@EndUserText.label : ''
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmepar_d {

  key mandt               : mandt not null;
  key matnr               : matnr not null;
  key omrme               : zomrme not null;
  key lifnr               : lifnr not null;
  key werks               : werks_d not null;
  indempa                 : abap.char(1);
  emnfr                   : abap.char(10);
  sperrfkt                : abap.char(2);
  sperrfktorig            : abap.char(2);
  msds                    : abap.numc(13);
  nummsdsorig             : abap.numc(13);
  msdsdoc                 : abap.char(17);
  indanexmsds             : abap.char(17);
  status                  : abap.char(1);
  statustext              : abap.char(3);
  suppliercompanyname     : abap.char(30);
  supplierbrazilphonecode : abap.char(16);
  supplieraddressid       : abap.char(10);
  suppliercountry         : abap.char(3);
  edithidden              : abap_boolean;
  userincl                : abap.char(12);
  dataincl                : abap.dats;
  horaincl                : abap.tims;
  useralt                 : abap.char(12);
  dataalt                 : abap.dats;
  horaalt                 : abap.tims;
  "%admin"                : include sych_bdl_draft_admin_inc;

}
