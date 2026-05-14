@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Classe GHS - Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZI_CHASSE_GHS_VH
  as select from ZI_CHASSE_GHS
{
      @EndUserText.label: 'Codigo GHS'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.text.element: ['Descricao']
  key CodGHS,

      @EndUserText.label: 'Frase'
      Descricao,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      DscPerPt,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      DscPerEn,

      @EndUserText.label: 'Palavra de Advertencia'
      PalavraAdvertencia,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      PalAdvPt,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      PalAdvEn
}
