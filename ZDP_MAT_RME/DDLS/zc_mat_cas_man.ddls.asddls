@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_MAT_CAS_MAN'
define view entity ZC_MAT_CAS_MAN
  as projection on ZI_MAT_CAS_MAN
{

  key Matnr,
  key Omrme,

      @Consumption.valueHelpDefinition: [ { entity : { name: 'ZI_MAT_CAS_NUMBER_VH', element: 'Codcas' },
                                            useForValidation: true
                                          } ]
  key Codcas,
  key Seqcas,
      Concentracao,
      ConcentracaoOri,
      DescricaoPt,
      DescricaoPtOri,
      DescricaoEn,
      DescricaoEnOri,
      InclCasNumber,
      Uname,
      Aedat,
      Uptim,

      @ObjectModel.text.element: ['StatusText']
      @UI.textArrangement: #TEXT_ONLY
      Status,
      StatusText,

      @ObjectModel.text.element: ['GrupoRestricaoDescricao']
      @UI.textArrangement: #TEXT_ONLY
      GrupoRestricao,
      _MatCasNumber.GrupoDescricao as GrupoRestricaoDescricao,

      /* Associations */
      _MatRme : redirected to parent ZC_MAT_RME
}
