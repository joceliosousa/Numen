@EndUserText.label : ''
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmecas_d {

  key mandt       : mandt not null;
  key matnr       : matnr not null;
  key omrme       : zomrme not null;
  key codcas      : abap.char(12) not null;
  key seqcas      : abap.numc(5) not null;
  concentracao    : abap.dec(5,2);
  concentracaoori : abap.dec(5,2);
  descricaopt     : abap.char(60);
  descricaoptori  : abap.char(60);
  descricaoen     : abap.char(60);
  descricaoenori  : abap.char(60);
  inclcasnumber   : abap_boolean;
  uname           : syuname;
  aedat           : abap.dats;
  uptim           : abap.tims;
  gruporestricao  : zgrupo_cas;
  status          : abap.char(1);
  statustext      : abap.char(3);
  "%admin"        : include sych_bdl_draft_admin_inc;

}
