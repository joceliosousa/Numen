@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_MAT_RME'
@ObjectModel.semanticKey: [ 'CompanyCode', 'Matnr', 'Mfrpn', 'Omrme' ]

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
      @UI.textArrangement: #TEXT_ONLY
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
      QtdCiclPrsv,
      QtdTpoPrsv,
      ZqtdTpoRtst,
      QtdCiclRtst,
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
      //      StatusCRUDCriticality,
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

      _CodOnu.ClasseRisco                       as ClasseRisco,
      _GrupoCas.GrupoCASDescription,

      Userincl,
      Datainc,
      Horaincl,
      Useralt,
      Dataalt,
      Horaalt,
      LocalLastChangedAt

}
