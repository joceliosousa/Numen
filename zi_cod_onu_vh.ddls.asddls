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
      //@ObjectModel.text.element: [ 'Descricao' ]
      @UI.lineItem: [ { position: 10 } ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key CodigoONU,

      @EndUserText.label: 'Grupo Embalagem'
      @UI.lineItem: [ { position: 60 } ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
  key GrupoEmbalagem,

      @EndUserText.label: 'Descrição'
      @UI.lineItem: [ { position: 20 } ]
      Descricao,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
      DescricaoPt,

      @UI.hidden: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      DescricaoEn,

      @EndUserText.label: 'Classe de Risco'
      @UI.lineItem: [ { position: 30 } ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      ClasseRisco,

      @EndUserText.label: 'Sub Classe de Risco'
      @UI.lineItem: [ { position: 40 } ]
      SubClasseRisco,

      @EndUserText.label: 'Numero de Risco'
      @UI.lineItem: [ { position: 50 } ]
      NumeroRisco,

      @EndUserText.label: 'Veiculo'
      @UI.lineItem: [ { position: 70 } ]
      Veiculo,

      @EndUserText.label: 'Embalagem Interna'
      @UI.lineItem: [ { position: 80 } ]
      EmbalagemInterna,

      @EndUserText.label: 'Classe Perigo Antiga'
      @UI.lineItem: [ { position: 90 } ]
      ClassePerigoAntiga
}
