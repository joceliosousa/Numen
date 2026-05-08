@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED MaterialRME'
define root view entity ZR_MAT_RME
  as select from ztdp_matrmema as MaterialMRE

  association [1..1] to ZI_STATUS_MAT_VH      as _StatusMat      on  $projection.CodSitMat = _StatusMat.StatusMaterial

  association [1..1] to I_CompanyCodeVH       as _CompanyCode    on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..1] to I_Supplier_VH         as _Supplier       on  $projection.Lifnr = _Supplier.Supplier

  association [0..1] to ZI_DP_TIPO_MAT_VH     as _TipoMaterial   on  (
        $projection.Matkl = _TipoMaterial.TipoMaterial
      )

  association [0..1] to ZI_PLTF_VH            as _TipoAenv       on  $projection.CodProjAenv = _TipoAenv.COD_PROJ_AENV

  association [0..1] to I_UnitOfMeasureStdVH  as _AusmeVH        on  $projection.Ausme = _AusmeVH.UnitOfMeasure

  association [0..1] to ZI_ORIGEM_MATERIAL_VH as _OrigemMaterial on  $projection.OrigemMaterial = _OrigemMaterial.OrigemMaterial

  association [0..1] to ZI_MAT_RME_APL        as _MatRmeApl      on  $projection.Matnr       = _MatRmeApl.Matnr
                                                                 and $projection.Omrme       = _MatRmeApl.Omrme
                                                                 and $projection.CodProjAenv = _MatRmeApl.CodProjAenv

  association [0..1] to ZI_IND_CONTROLE_VH    as _IndControle    on  $projection.IndRastb = _IndControle.IndicadorControle

  association [0..1] to ZI_COD_ONU_VH         as _CodOnu         on  $projection.CodOnu = _CodOnu.CodigoONU
                                                                 and $projection.GrpEmb = _CodOnu.GrupoEmbalagem

  association [0..1] to ZI_GRUPO_CAS_VH       as _GrupoCas       on  $projection.GrauRestricao = _GrupoCas.GrupoCAS

{
      @Consumption.valueHelpDefinition: [ { entity : { name: 'I_PRODUCTSTDVH', element: 'Product' },
                                            useForValidation: true }]
  key matnr                          as Matnr,
  key omrme                          as Omrme,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                            useForValidation: true }]
      bukrs                          as CompanyCode,
      mfrpn                          as Mfrpn,
      mfrpn_an                       as MfrpnAn,
      @Semantics.user.createdBy: true
      owner                          as Owner,
      cod_pcr_des                    as CodPcrDes,
      cod_pcr_prcd                   as CodPcrPrcd,
      //@ObjectModel.text.element: ['SupplierName']
      lifnr                          as Lifnr,
      @Semantics.text: true
      _Supplier.SupplierName         as SupplierName,
      emnfr                          as Emnfr,
      zmstae                         as Zmstae,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_STATUS_MAT_VH',
            element: 'StatusMaterial'
          },
          useForValidation: true
        }
      ]
      cod_sit_mat                    as CodSitMat,
      cast( 'NEW' as abap.char(4))   as StatusCRUD,
      //      '3'                            as StatusCRUDCriticality,
      cast(
        case when cod_sit_mat = 'K' then 2
             when cod_sit_mat = 'D' then 1
             when cod_sit_mat = 'L' then 3
             else 2
        end as abap.int1
      )                              as SitMatCriticality,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_PLTF_VH',
            element: 'COD_PROJ_AENV'
          },
          useForValidation: true
        }
      ]
      cod_proj_aenv                  as CodProjAenv,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_MAT_RME_TPDOCUMENTO_VH', element: 'TipoDocumento' },
                                            useForValidation: true
                                          } ]
      _MatRmeApl.Doctype             as Doctype,
      _MatRmeApl.Docnro              as Docnro,
      dscexpen                       as Dscexpen,
      dscresen                       as Dscresen,
      dscexppt                       as Dscexppt,
      dscrespt                       as Dscrespt,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_DP_TIPO_MAT_VH', element: 'TipoMaterial' },
                                            useForValidation: true
                                          } ]
      matkl                          as Matkl,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_ORIGEM_MATERIAL_VH', element: 'OrigemMaterial' },
                                            useForValidation: true
                                          } ]
      origem_material                as OrigemMaterial,
      ferth                          as Ferth,
      normt                          as Normt,
      num_cap_rme                    as NumCapRme,
      num_sucp_rme                   as NumSucpRme,
      num_scao_rme                   as NumScaoRme,
      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_IND_CONTROLE_VH', element: 'IndicadorControle' },
                                            useForValidation: true
                                          } ]
      ind_rastb                      as IndRastb,
      xchpf                          as Xchpf,
      sernp                          as Sernp,
      groes                          as Groes,
      meins                          as Meins,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' },
        useForValidation: true
      }]
      ausme                          as Ausme,
      @Semantics.text: true
      _AusmeVH.UnitOfMeasureLongName as AusmeText,
      @Semantics.quantity.unitOfMeasure: 'AUSME'
      vlr_pes_calc                   as VlrPesCalc,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      ntgew                          as Ntgew,
      aprogrup                       as Aprogrup,
      profl                          as Profl,
      raube                          as Raube,
      mhdhb                          as Mhdhb,
      qtd_cicl_prsv                  as QtdCiclPrsv,
      qtd_tpo_prsv                   as QtdTpoPrsv,
      zqtd_tpo_rtst                  as ZqtdTpoRtst,
      qtd_cicl_rtst                  as QtdCiclRtst,
      anaresp                        as Anaresp,
      tipmod                         as Tipmod,
      approver                       as Approver,
      ind_repn_item                  as IndRepnItem,
      indomrme                       as Indomrme,
      ind_tso                        as IndTso,
      cod_cpl                        as CodCpl,
      @Consumption.valueHelpDefinition: [
        {
          entity: {
            name: 'ZI_COD_ONU_VH',
            element: 'CodigoONU'
          },
          useForValidation: true
        }
      ]
      cod_onu                        as CodOnu,
      grp_emb                        as GrpEmb,
      rel_mon                        as RelMon,
      cod_certif                     as CodCertif,
      grau_restricao                 as GrauRestricao,
      usercomit                      as Usercomit,
      matctrl                        as Matctrl,
      userincl                       as Userincl,
      datainc                        as Datainc,
      horaincl                       as Horaincl,
      useralt                        as Useralt,
      dataalt                        as Dataalt,
      horaalt                        as Horaalt,
      //      $session.system_language             as Language,
      @Semantics.user.createdBy: true
      createdby                      as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat                      as Createdat,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at          as LocalLastChangedAt,

      _CompanyCode,
      _StatusMat,
      _TipoMaterial,
      _TipoAenv,
      _AusmeVH,
      _OrigemMaterial,
      _MatRmeApl,
      _IndControle,
      _CodOnu,
      _GrupoCas

}
