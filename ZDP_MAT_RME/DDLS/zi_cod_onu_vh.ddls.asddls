@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - Codigo ONU'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZI_COD_ONU_VH
  as select from ZI_COD_ONU
{
      @EndUserText.label: 'Codigo ONU'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key CodigoONU,

      @EndUserText.label: 'Grupo Embalagem'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
  key GrupoEmbalagem,

      @EndUserText.label: 'Descrição'
      Descricao,

      @EndUserText.label: 'Classe de Risco'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      ClasseRisco,

      @EndUserText.label: 'Sub Classe de Risco'
      SubClasseRisco,

      @EndUserText.label: 'Numero de Risco'
      NumeroRisco,

      @EndUserText.label: 'Veiculo'
      Veiculo,

      @EndUserText.label: 'Embalagem Interna'
      EmbalagemInterna,

      @EndUserText.label: 'Classe Perigo Antiga'
      ClassePerigoAntiga,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      DescricaoPt,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      DescricaoEn
}
