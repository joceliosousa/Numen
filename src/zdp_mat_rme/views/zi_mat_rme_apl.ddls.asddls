@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material RME Aplicacao'
define view entity ZI_MAT_RME_APL
  as select from ztdp_matrmeaplma
{
  key matnr         as Matnr,
  key omrme         as Omrme,
  key cod_proj_aenv as CodProjAenv,
  key doctype       as Doctype,
  key docnro        as Docnro,
      status        as Status,
      codpltf_orig  as CodpltfOrig,
      userincl      as Userincl,
      dataincl      as Dataincl,
      horaincl      as Horaincl,
      useralt       as Useralt,
      dataalt       as Dataalt,
      horaalt       as Horaalt
}