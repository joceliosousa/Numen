@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED MaterialRME'
define root view entity ZR_MAT_RME
  as select from    ztdp_matrmema        as MaterialMRE

    left outer join ZI_MAT_RME_APL_FIRST as _MatRmeAplFirst on  MaterialMRE.matnr = _MatRmeAplFirst.Matnr
                                                            and MaterialMRE.omrme = _MatRmeAplFirst.Omrme

    left outer join ZI_MAT_RME_APL       as _MatRmeApl      on(
           _MatRmeAplFirst.Matnr           = _MatRmeApl.Matnr
           and _MatRmeAplFirst.Omrme       = _MatRmeApl.Omrme
           and _MatRmeAplFirst.DatainclMin = _MatRmeApl.Dataincl
           and _MatRmeAplFirst.HorainclMin = _MatRmeApl.Horaincl
         )

  association [1..1] to ZI_STATUS_MAT_VH       as _StatusMat      on  $projection.CodSitMat = _StatusMat.StatusMaterial

  association [1..1] to I_CompanyCodeVH        as _CompanyCode    on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..1] to I_Supplier_VH          as _Supplier       on  $projection.Lifnr = _Supplier.Supplier

  association [0..1] to ZI_DP_TIPO_MAT_VH      as _TipoMaterial   on  (
        $projection.Matkl = _TipoMaterial.TipoMaterial
      )

  association [0..1] to ZI_PLTF_VH             as _TipoAenv       on  $projection.CodProjAenv = _TipoAenv.COD_PROJ_AENV

  association [0..1] to I_UnitOfMeasureStdVH   as _AusmeVH        on  $projection.Ausme = _AusmeVH.UnitOfMeasure

  association [0..1] to ZI_ORIGEM_MATERIAL_VH  as _OrigemMaterial on  $projection.OrigemMaterial = _OrigemMaterial.OrigemMaterial


  //and $projection.CodProjAenv = _MatRmeApl.CodProjAenv

  association [0..1] to ZI_IND_CONTROLE_VH     as _IndControle    on  $projection.IndRastb = _IndControle.IndicadorControle

  association [0..1] to ZI_COD_ONU_VH          as _CodOnu         on  $projection.CodOnu = _CodOnu.CodigoONU
                                                                  and $projection.GrpEmb = _CodOnu.GrupoEmbalagem

  association [0..1] to ZI_GRUPO_CAS_VH        as _GrupoCas       on  $projection.GrauRestricao = _GrupoCas.GrupoRestricao

  association [0..1] to ZI_PlainLongText       as _TextManPer     on  (
          _TextManPer.TextObjectCategory = 'ZMANPER'
          and _TextManPer.TextObjectType = 'IVER'
          and _TextManPer.TextObjectKey  = $projection.Omrme
          and _TextManPer.Language       = $session.system_language
        )


  association [0..1] to ZI_PlainLongText       as _TextManPre     on  (
          _TextManPre.TextObjectCategory = 'ZMANPRE'
          and _TextManPre.TextObjectType = 'IVER'
          and _TextManPre.TextObjectKey  = $projection.Omrme
          and _TextManPre.Language       = $session.system_language
        )

  association [0..1] to ZI_PlainLongText       as _TextManRet     on  (
          _TextManRet.TextObjectCategory = 'ZMANRET'
          and _TextManRet.TextObjectType = 'IVER'
          and _TextManRet.TextObjectKey  = $projection.Omrme
          and _TextManRet.Language       = $session.system_language
        )

  association [0..1] to ZI_PlainLongText       as _TextManNot     on  (
          _TextManNot.TextObjectCategory = 'ZMANNOT'
          and _TextManNot.TextObjectType = 'IVER'
          and _TextManNot.TextObjectKey  = $projection.Omrme
          and _TextManNot.Language       = $session.system_language
        )

  association [0..1] to ZI_MATERIAL_CLASSE_GHS as _ClasseGHS      on  (
           _ClasseGHS.Material  = $projection.Matnr
           and _ClasseGHS.Omrme = $projection.Omrme
         )

  association [0..1] to ZI_CHASSE_GHS_VH       as _ClasseGHSDesc  on  (
       _ClasseGHSDesc.CodGHS = $projection.CodGHS
     )

  composition of many ZI_TSOJTSO_MAN           as _TsoJtso
  composition of many ZI_MAT_CAS_MAN           as _MatCas
  composition of many zi_mat_rme_control       as _CtrlMat
  composition of many ZI_MAT_RME_APL           as _MatPrograma
  composition of many ZI_MAT_RME_FORN          as _MatFornecedor
  composition of many ZI_MAT_RME_PARC          as _MatParceiro
  composition of many ZI_MAT_RME_KIT           as _MatKit

{
      @Consumption.valueHelpDefinition: [ { entity : { name: 'I_PRODUCTSTDVH', element: 'Product' },
                                            useForValidation: true }]
  key MaterialMRE.matnr                                                                      as Matnr,
  key MaterialMRE.omrme                                                                      as Omrme,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                            useForValidation: true }]
      MaterialMRE.bukrs                                                                      as CompanyCode,
      MaterialMRE.mfrpn                                                                      as Mfrpn,
      MaterialMRE.mfrpn_an                                                                   as MfrpnAn,
      @Semantics.user.createdBy: true
      MaterialMRE.owner                                                                      as Owner,
      MaterialMRE.cod_pcr_des                                                                as CodPcrDes,
      MaterialMRE.cod_pcr_prcd                                                               as CodPcrPrcd,
      //@ObjectModel.text.element: ['SupplierName']
      MaterialMRE.lifnr                                                                      as Lifnr,
      @Semantics.text: true
      _Supplier.SupplierName                                                                 as SupplierName,
      MaterialMRE.emnfr                                                                      as Emnfr,
      MaterialMRE.zmstae                                                                     as Zmstae,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_STATUS_MAT_VH',
            element: 'StatusMaterial'
          },
          useForValidation: true
        }
      ]
      MaterialMRE.cod_sit_mat                                                                as CodSitMat,
      cast( 'NEW' as abap.char(4))                                                           as StatusCRUD,
      cast(' ' as abap_boolean preserving type )                                             as CreateHidden,
      //      '3'                            as StatusCRUDCriticality,
      cast(
        case when MaterialMRE.cod_sit_mat = 'K' then 2
             when MaterialMRE.cod_sit_mat = 'D' then 1
             when MaterialMRE.cod_sit_mat = 'L' then 3
             else 2
        end as abap.int1
      )                                                                                      as SitMatCriticality,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_PLTF_VH',
            element: 'COD_PROJ_AENV'
          },
          useForValidation: true
        }
      ]
      MaterialMRE.cod_proj_aenv                                                              as CodProjAenv,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_MAT_RME_TPDOCUMENTO_VH', element: 'TipoDocumento' },
                                            useForValidation: true
                                          } ]
      _MatRmeApl.Doctype                                                                     as Doctype,
      _MatRmeApl.Docnro                                                                      as Docnro,
      MaterialMRE.dscexpen                                                                   as Dscexpen,
      MaterialMRE.dscresen                                                                   as Dscresen,
      MaterialMRE.dscexppt                                                                   as Dscexppt,
      MaterialMRE.dscrespt                                                                   as Dscrespt,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_DP_TIPO_MAT_VH', element: 'TipoMaterial' },
                                            useForValidation: true
                                          } ]
      MaterialMRE.matkl                                                                      as Matkl,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_ORIGEM_MATERIAL_VH', element: 'OrigemMaterial' },
                                            useForValidation: true
                                          } ]
      MaterialMRE.origem_material                                                            as OrigemMaterial,
      MaterialMRE.ferth                                                                      as Ferth,
      MaterialMRE.normt                                                                      as Normt,
      MaterialMRE.num_cap_rme                                                                as NumCapRme,
      MaterialMRE.num_sucp_rme                                                               as NumSucpRme,
      MaterialMRE.num_scao_rme                                                               as NumScaoRme,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_IND_CONTROLE_VH', element: 'IndicadorControle' },
                                            useForValidation: true
                                          } ]
      MaterialMRE.ind_rastb                                                                  as IndRastb,
      MaterialMRE.xchpf                                                                      as Xchpf,
      MaterialMRE.sernp                                                                      as Sernp,
      MaterialMRE.groes                                                                      as Groes,
      MaterialMRE.meins                                                                      as Meins,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' },
        useForValidation: true
      }]
      MaterialMRE.ausme                                                                      as Ausme,
      @Semantics.text: true
      _AusmeVH.UnitOfMeasureLongName                                                         as AusmeText,
      @Semantics.quantity.unitOfMeasure: 'AUSME'
      MaterialMRE.vlr_pes_calc                                                               as VlrPesCalc,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      MaterialMRE.ntgew                                                                      as Ntgew,
      MaterialMRE.aprogrup                                                                   as Aprogrup,
      MaterialMRE.profl                                                                      as Profl,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_MAT_COND_ESTOCAGEM', element: 'Raube' },
                                            useForValidation: true
                                          } ]
      MaterialMRE.raube                                                                      as Raube,
      //      MaterialMRE.mhdhb                                                                                  as Mhdhb,
      MaterialMRE.qtd_cicl_prsv                                                              as QtdCiclPrsv,
      '00'                                                                                   as QtdCiclPerec,
      MaterialMRE.qtd_tpo_prsv                                                               as QtdTpoPrsv,
      MaterialMRE.mhdhb                                                                      as QtdTpoPerec,
      MaterialMRE.zqtd_tpo_rtst                                                              as ZqtdTpoRtst,
      MaterialMRE.qtd_cicl_rtst                                                              as QtdCiclRtst,
      MaterialMRE.anaresp                                                                    as Anaresp,
      MaterialMRE.tipmod                                                                     as Tipmod,
      MaterialMRE.approver                                                                   as Approver,
      MaterialMRE.ind_repn_item                                                              as IndRepnItem,
      MaterialMRE.indomrme                                                                   as Indomrme,
      MaterialMRE.ind_tso                                                                    as IndTso,
      MaterialMRE.cod_cpl                                                                    as CodCpl,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_COD_ONU_VH',
            element: 'CodigoONU'
          },
          additionalBinding: [
            {
              localElement: 'GrpEmb',
              element: 'GrupoEmbalagem',
              usage: #RESULT
            },
            {
              localElement: 'ClasseRisco',
              element: 'ClasseRisco',
              usage: #RESULT
            }
          ],
          useForValidation: true
        }
      ]
      MaterialMRE.cod_onu                                                                    as CodOnu,
      MaterialMRE.grp_emb                                                                    as GrpEmb,
      MaterialMRE.rel_mon                                                                    as RelMon,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_CHASSE_GHS_VH', element: 'CodGHS' },
                                            useForValidation: true
                                          } ]
      _ClasseGHS.CodGHS                                                                      as CodGHS,

      MaterialMRE.cod_certif                                                                 as CodCertif,
      MaterialMRE.grau_restricao                                                             as GrauRestricao,
      MaterialMRE.usercomit                                                                  as Usercomit,

      _CodOnu.ClasseRisco                                                                    as ClasseRisco,
      MaterialMRE.matctrl                                                                    as Matctrl,
      @Semantics.user.createdBy: true
      MaterialMRE.userincl                                                                   as Createdby,

      // Texto longo

      @EndUserText.label: 'Texto Perecível'
      _TextManPer.PlainLongText                                                              as ManperText,
      cast( case when _TextManPer.TextoExiste is null then '' else 'X' end as abap_boolean ) as MaterialPerecivel,

      @EndUserText.label: 'Texto Preservável'
      _TextManPre.PlainLongText                                                              as ManpreText,
      cast( case when _TextManPre.TextoExiste is null then '' else 'X' end as abap_boolean ) as MaterialPreservavel,

      @EndUserText.label: 'Texto Retestável'
      _TextManRet.PlainLongText                                                              as ManretText,
      cast( case when _TextManRet.TextoExiste is null then '' else 'X' end as abap_boolean ) as MaterialRetestavel,

      @EndUserText.label: 'Texto Notas'
      _TextManNot.PlainLongText                                                              as MannotText,

      cast(
        ''
        as abap.char(1024)
      )                                                                                      as DmsDocumentUrl,
      'Help doc-emb-00668'                                                                   as DmsDocumentText,

      'https://embraer.docspider.com.br/PortalDocumentos/?portalID=1'                        as DocEmbraerUrl,
      'Help doc-emb-00668'                                                                   as DocEmbraerText,

      MaterialMRE.datainc                                                                    as Datainc,
      MaterialMRE.horaincl                                                                   as Horaincl,

      @Semantics.user.lastChangedBy: true
      MaterialMRE.useralt                                                                    as Useralt,
      MaterialMRE.dataalt                                                                    as Dataalt,
      MaterialMRE.horaalt                                                                    as Horaalt,
      //      $session.system_language             as Language,
      @Semantics.systemDateTime.createdAt: true
      MaterialMRE.createdat                                                                  as Createdat,
      @Semantics.systemDateTime.lastChangedAt: true
      MaterialMRE.last_changed_at                                                            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      MaterialMRE.local_last_changed_at                                                      as LocalLastChangedAt,

      /* Associations */
      _CompanyCode,
      _StatusMat,
      _TipoMaterial,
      _TipoAenv,
      _AusmeVH,
      _OrigemMaterial,
      //      _MatRmeApl,
      _IndControle,
      _CodOnu,
      _GrupoCas,
      _ClasseGHSDesc,
      _TsoJtso,
      _MatCas,
      _CtrlMat,
      _MatPrograma,
      _MatFornecedor,
      _MatParceiro,
      _MatKit

}
