@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda pesquisa Classificacao RME'
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZI_VH_MAT_RME_CLASSIFICACAO as select from ZI_MAT_RME_CLASSIFICACAO
{        
    key cast(concat(concat(concat(concat(NumCapRme,'-'),NumSucpRme),'-'),NumScaoRme) as abap.char(10)) as RME,
    NumCapRme,
    NumSucpRme,
    NumScaoRme,
    Descricaopt,
    Descricaoen    
}
