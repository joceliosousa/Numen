@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_MAT_RME'
@ObjectModel.semanticKey: [ 'CompanyCode', 'Matnr', 'Mfrpn', 'Omrme' ]
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_MAT_RME
  provider contract transactional_query
  as projection on ZR_MAT_RME

{

  key Matnr,
  key Omrme,
      Mfrpn,
      MfrpnAn,
      Owner,
      CodPcrDes,
      CodPcrPrcd,
      @ObjectModel.text.element: ['SupplierName']
      @Consumption.valueHelpDefinition: [{
        entity: {
          name: 'I_Supplier_VH',
          element: 'Supplier'
        }
      }]
      @UI.textArrangement: #TEXT_LAST
      Lifnr,
      SupplierName,
      Emnfr,
      Zmstae,
      @ObjectModel.text.element: ['TipoAenvDesc']
      @UI.textArrangement: #TEXT_LAST
      CodProjAenv,
      _TipoAenv.DSCPLTF                         as TipoAenvDesc,
      Dscexpen,
      Dscresen,
      Dscexppt,
      Dscrespt,
      @ObjectModel.text.element: ['TipoMatDesc']
      @UI.textArrangement: #TEXT_LAST
      Matkl,
      _TipoMaterial.Descricao                   as TipoMatDesc,
      @ObjectModel.text.element: ['OrigemMaterialDesc']
      @UI.textArrangement: #TEXT_LAST
      OrigemMaterial,
      _OrigemMaterial.OrigemMaterialDescription as OrigemMaterialDesc,
      Ferth,
      Normt,
      NumCapRme,
      NumSucpRme,
      NumScaoRme,
      @ObjectModel.text.element: ['IndRastbDesc']
      @UI.textArrangement: #TEXT_LAST
      IndRastb,
      _IndControle.IndicadorControleDescription as IndRastbDesc,
      Xchpf,
      Sernp,
      Groes,
      Meins,
      @ObjectModel.text.element: ['AusmeText']
      @UI.textArrangement: #TEXT_LAST
      Ausme,
      AusmeText,
      VlrPesCalc,
      Ntgew,
      Aprogrup,
      Profl,
      Raube,
      Mhdhb,
      Anaresp,
      Tipmod,
      Approver,
      IndRepnItem,
      Indomrme,
      IndTso,
      CodCpl,
      CodOnu,
      GrpEmb,
      RelMon,
      CodCertif,

      @ObjectModel.text.element: ['CodSitMatText']
      @UI.textArrangement: #TEXT_ONLY
      CodSitMat,
      _StatusMat.StatusMaterialDescription      as CodSitMatText,
      StatusCRUD,
      SitMatCriticality,

      @ObjectModel.text.element: ['CompanyCodeText']
      @UI.textArrangement: #TEXT_ONLY
      CompanyCode,
      _CompanyCode.CompanyCodeName              as CompanyCodeText,
      Doctype,
      Docnro,
      GrauRestricao,
      Usercomit,
      Matctrl,

      ClasseRisco,
      _GrupoCas.GrupoCASDescription,

      @ObjectModel.text.element: ['ClasseGHSDesc']
      @UI.textArrangement: #TEXT_LAST
      CodGHS,
      _ClasseGHSDesc.Descricao                  as ClasseGHSDesc,

      // dados de preservação e perecibilidade
      QtdCiclPerec                              as QtdCicloPerecivel,
      QtdCiclPrsv                               as QtdCicloPreservacao,
      QtdTpoPrsv                                as QtdTempoPreservacao,
      QtdTpoPerec                               as QtdTempoPerecivel,
      ZqtdTpoRtst                               as QtdTempoRetestavel,
      QtdCiclRtst                               as QtdCicloRetestavel,

      MaterialPerecivel,
      ManperText                                as MaterialPerecivelText,

      MaterialPreservavel,
      ManpreText                                as MaterialPreservavelText,

      MaterialRetestavel,
      ManretText                                as MaterialRetestavelText,

      Userincl,
      Datainc,
      Horaincl,
      Useralt,
      Dataalt,
      Horaalt,
      LocalLastChangedAt,

      _TsoJtsoData

}
