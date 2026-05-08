@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Codigo ONU'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MASTER
}
define view entity ZI_COD_ONU
  as select from ztdp_cod_onu
{
      @EndUserText.label: 'Codigo ONU'
  key cod_onu                           as CodigoONU,

      @EndUserText.label: 'Grupo de Embalagem'
  key grp_emb                           as GrupoEmbalagem,

      cast(  case cast( $session.system_language as spras)
             when 'P' then nome_desc_pt
             when 'E' then nome_desc_en
             else nome_desc_en
        end      as    abap.char(100) ) as Descricao,

      cast ( case cast( $session.system_language as spras)
             when 'P' then 'X'
             else ''
        end      as abap_boolean )      as hideEN,

      cast( case cast( $session.system_language as spras)
             when 'E' then 'X'
             else ''
        end      as abap_boolean )      as hidePT,

      @EndUserText.label: 'Descricao (PT)'
      nome_desc_pt                      as DescricaoPt,

      @EndUserText.label: 'Descricao (EN)'
      nome_desc_en                      as DescricaoEn,

      @EndUserText.label: 'Classe de Risco'
      clas_ris                          as ClasseRisco,

      @EndUserText.label: 'Sub-Classe de Risco'
      sub_clas_ris                      as SubClasseRisco,

      @EndUserText.label: 'Numero de Risco'
      num_ris                           as NumeroRisco,

      @EndUserText.label: 'Veiculo'
      veiculo                           as Veiculo,

      @EndUserText.label: 'Embalagem Interna'
      emb_int                           as EmbalagemInterna,

      @EndUserText.label: 'Classe de Perigo Antiga'
      clas_per_ant                      as ClassePerigoAntiga,

      @EndUserText.label: 'Artigo'
      indic_artigo                      as IndicadorArtigo,

      @EndUserText.label: 'Codigo ONU Instalado'
      cod_inst                          as CodigoOnuInstalado,

      @EndUserText.label: 'Historico Ultimo ONU Instalado'
      cod_inst_ant                      as CodigoOnuInstaladoAnterior,

      @EndUserText.label: 'Relevante'
      relevante                         as Relevante,

      @EndUserText.label: 'Data da Ultima Modificacao'
      aedat                             as DataUltimaModificacao,

      @EndUserText.label: 'Responsavel'
      ernam                             as Responsavel
}
