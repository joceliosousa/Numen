@EndUserText.label : '##GENERATED MaterialRME'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmema_d {

  key mandt           : mandt not null;
  key matnr           : matnr not null;
  key omrme           : zomrme not null;
  companycode         : bukrs;
  mfrpn               : abap.char(40);
  mfrpnan             : abap.char(40);
  owner               : syuname;
  codpcrdes           : abap.numc(5);
  codpcrprcd          : abap.numc(5);
  lifnr               : lifnr;
  suppliername        : name1_gp;
  emnfr               : abap.char(10);
  zmstae              : abap.char(2);
  codsitmat           : abap.char(1);
  statuscrud          : abap.char(4);
  createhidden        : abap_boolean;
  sitmatcriticality   : abap.int1;
  codprojaenv         : abap.char(4);
  doctype             : abap.char(5);
  docnro              : abap.char(15);
  dscexpen            : abap.char(65);
  dscresen            : abap.char(35);
  dscexppt            : abap.char(65);
  dscrespt            : abap.char(35);
  matkl               : abap.char(9);
  origemmaterial      : zorigem;
  ferth               : abap.char(18);
  normt               : abap.char(18);
  numcaprme           : abap.char(2);
  numsucprme          : abap.char(2);
  numscaorme          : abap.char(3);
  indrastb            : abap.char(1);
  xchpf               : abap.char(1);
  sernp               : abap.char(4);
  groes               : abap.char(32);
  meins               : meins;
  ausme               : abap.unit(3);
  ausmetext           : msehl;
  @Semantics.quantity.unitOfMeasure : 'ztdp_matrmema_d.ausme'
  vlrpescalc          : abap.quan(13,3);
  @Semantics.quantity.unitOfMeasure : 'ztdp_matrmema_d.meins'
  ntgew               : abap.quan(13,3);
  aprogrup            : abap.char(2);
  profl               : abap.char(3);
  raube               : abap.char(2);
  qtdciclprsv         : abap.numc(2);
  qtdciclperec        : abap.numc(2);
  qtdtpoprsv          : abap.numc(5);
  qtdtpoperec         : abap.dec(4,0);
  zqtdtportst         : abap.numc(5);
  qtdciclrtst         : abap.numc(2);
  anaresp             : syuname;
  tipmod              : abap.char(1);
  approver            : syuname;
  indrepnitem         : abap.char(1);
  indomrme            : abap.char(1);
  indtso              : abap_boolean;
  codcpl              : abap.char(1);
  codonu              : abap.char(4);
  grpemb              : abap.char(3);
  relmon              : abap_boolean;
  codghs              : abap.char(4);
  codcertif           : abap.char(1);
  graurestricao       : abap.char(1);
  usercomit           : abap.char(12);
  classerisco         : abap.char(4);
  matctrl             : abap_boolean;
  createdby           : syuname;
  manpertext          : esh_e_sr_longtext;
  materialperecivel   : abap_boolean;
  manpretext          : esh_e_sr_longtext;
  materialpreservavel : abap_boolean;
  manrettext          : esh_e_sr_longtext;
  materialretestavel  : abap_boolean;
  mannottext          : esh_e_sr_longtext;
  dmsdocumenturl      : abap.char(1024);
  dmsdocumenttext     : abap.char(18);
  docembraerurl       : abap.char(61);
  docembraertext      : abap.char(18);
  datainc             : abap.dats;
  horaincl            : abap.tims;
  useralt             : syuname;
  dataalt             : abap.dats;
  horaalt             : abap.tims;
  createdat           : abp_creation_tstmpl;
  lastchangedat       : abp_lastchange_tstmpl;
  locallastchangedat  : abp_locinst_lastchange_tstmpl;
  "%admin"            : include sych_bdl_draft_admin_inc;

}
