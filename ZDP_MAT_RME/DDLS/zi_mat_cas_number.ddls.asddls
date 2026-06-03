@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS interface CAS Number'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MAT_CAS_NUMBER
  as select from ztdp_cas_number

  association [0..1] to ZI_GRUPO_CAS_VH as _GrupoCas on $projection.GrupoRestricao = _GrupoCas.GrupoRestricao

{
  key codcas                              as Codcas,
      grupo                               as GrupoRestricao,
      _GrupoCas.GrupoRestricaoDescription as GrupoDescricao,
      descas_pt                           as DescasPt,
      descas_en                           as DescasEn,
      uname                               as Uname,
      aedat                               as Aedat,
      uptim                               as Uptim,
      status                              as Status
}
