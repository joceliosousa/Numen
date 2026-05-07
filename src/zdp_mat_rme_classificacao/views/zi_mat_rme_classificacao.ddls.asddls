@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Classificação RME'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_RME_CLASSIFICACAO as select from ztdp_rme
{
    key num_cap_rme as NumCapRme,
    key num_sucp_rme as NumSucpRme,
    key num_scao_rme as NumScaoRme,
    descricaopt as Descricaopt,
    descricaoen as Descricaoen,
    catmat as Catmat,
    clasferr as Clasferr,
    meins as Meins,
    qtde_min as QtdeMin,
    qtde_max as QtdeMax,
    indic_perig as IndicPerig,
    relev_prox_mont as RelevProxMont,
    created_by as CreatedBy,
    created_at as CreatedAt,
    changed_by as ChangedBy,
    changed_at as ChangedAt
}