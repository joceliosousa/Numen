@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH Licencas Embraer NextLabs'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZI_NXL_LICENSE_EMB_VH
  as select from znxl_license_emb
{

      @EndUserText.label: 'Tipo Licenca'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key expsec   as ExpSecurity,

      @EndUserText.label: 'ID Engenharia'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key licenses as ExportLicense
}
