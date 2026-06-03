@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - Codigo ONU'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZI_MAT_CAS_NUMBER_VH
  as select from ZI_MAT_CAS_NUMBER
{
      @EndUserText.label: 'CAS Number'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key Codcas,

      @EndUserText.label: 'Descrição em Português'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      DescasPt,

      @EndUserText.label: 'Descrição em Inglês'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      DescasEn,

      @EndUserText.label: 'Grau Risco'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      GrupoDescricao
}
