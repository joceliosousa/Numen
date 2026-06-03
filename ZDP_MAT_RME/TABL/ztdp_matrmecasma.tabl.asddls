@EndUserText.label : 'ZDPTMM061 - Atribuição Material x CAS Nbr x Concentração (M)'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_matrmecasma {

  key mandt        : abap.clnt not null;
  key codemb       : matnr not null;
  key omrme        : zomrme not null;
  key codcas       : abap.char(12) not null;
  key seqcas       : abap.numc(5) not null;
  concentracao     : abap.dec(5,2);
  concentracao_ori : abap.dec(5,2);
  descricao_pt     : abap.char(60);
  descricao_pt_ori : abap.char(60);
  descricao_en     : abap.char(60);
  descricao_en_ori : abap.char(60);
  incl_cas_number  : abap_boolean;
  uname            : syuname;
  aedat            : abap.dats;
  uptim            : abap.tims;
  status           : abap.char(1);

}
