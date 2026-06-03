@EndUserText.label : 'ZDPTMM055 - Código ONU (ATENÇÂO: Rotinas Evento pgm Gerador)'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztdp_cod_onu {

  @EndUserText.label : 'Mandante'
  key client   : abap.clnt not null;
  @EndUserText.label : 'Código ONU'
  key cod_onu  : abap.char(4) not null;
  @EndUserText.label : 'Grupo de Embalagem'
  key grp_emb  : abap.char(3) not null;
  @EndUserText.label : 'Linha de texto descritiva'
  nome_desc_pt : abap.char(255);
  @EndUserText.label : 'Linha de texto descritiva'
  nome_desc_en : abap.char(255);
  @EndUserText.label : 'Classe de Risco'
  clas_ris     : abap.char(4);
  @EndUserText.label : 'Sub-Classe de Risco'
  sub_clas_ris : abap.char(10);
  @EndUserText.label : 'Número de Risco'
  num_ris      : abap.char(4);
  @EndUserText.label : 'Veículo'
  veiculo      : abap.char(10);
  @EndUserText.label : 'Embalagem Interna'
  emb_int      : abap.char(10);
  @EndUserText.label : 'Classe de perigo Antiga'
  clas_per_ant : abap.char(3);
  @EndUserText.label : 'Artigo'
  indic_artigo : abap.char(1);
  @EndUserText.label : 'Código ONU'
  cod_inst     : abap.char(4);
  @EndUserText.label : 'Histórico do último ONU Instalado que foi processado'
  cod_inst_ant : abap.char(4);
  @EndUserText.label : 'Relevante'
  relevante    : abap.char(1);
  @EndUserText.label : 'Data da última modificação'
  aedat        : abap.dats;
  @EndUserText.label : 'Nome do responsável que adicionou o objeto'
  ernam        : abap.char(12);

}
