@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Atrib. Material x CAS Nbr x Concentração'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MAT_CAS_MAN
  as select from ztdp_matrmecasma

  association        to parent ZR_MAT_RME as _MatRme       on  _MatRme.Matnr = $projection.Matnr
                                                           and _MatRme.Omrme = $projection.Omrme

  association [1..1] to ZI_MAT_CAS_NUMBER as _MatCasNumber on  _MatCasNumber.Codcas = $projection.Codcas

{

  key codemb                       as Matnr,
  key omrme                        as Omrme,
  key codcas                       as Codcas,
  key seqcas                       as Seqcas,
      concentracao                 as Concentracao,
      concentracao_ori             as ConcentracaoOri,
      descricao_pt                 as DescricaoPt,
      descricao_pt_ori             as DescricaoPtOri,
      descricao_en                 as DescricaoEn,
      descricao_en_ori             as DescricaoEnOri,
      incl_cas_number              as InclCasNumber,
      @Semantics.user.createdBy: true
      uname                        as Uname,
      aedat                        as Aedat,
      uptim                        as Uptim,

      _MatCasNumber.GrupoRestricao as GrupoRestricao,

      status                       as Status,

      //--Definir status
      case status
        when 'A' then 'ADD'
        when 'U' then 'UPD'
        when 'D' then 'DEL'
        else ' '
        end                        as StatusText,

      /* Associations */
      _MatRme,
      _MatCasNumber

}
