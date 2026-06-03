@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_MAT_RME_KIT'
define view entity ZC_MAT_RME_KIT
  as projection on ZI_MAT_RME_KIT
{

  key Matnr,
  key Omrme,
  key Matnrkit,

      CodigoEmbraer,

      _Product._Text[1: Language='E'].ProductName as DesignacaoIngles,
      _Product.BaseUnit                           as UnidadeBasica,

      Qtde,
      QtdeOrig,

      @ObjectModel.text.element: ['StatusText']
      @UI.textArrangement: #TEXT_ONLY
      Status,
      StatusText,

      Userincl,
      Dataincl,
      Horaincl,
      Useralt,
      Dataalt,
      Horaalt,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MAT_RME_CREATE_HIDDEN'
      EditHidden,

      /* Associations */
      _MatRme : redirected to parent ZC_MAT_RME

}
