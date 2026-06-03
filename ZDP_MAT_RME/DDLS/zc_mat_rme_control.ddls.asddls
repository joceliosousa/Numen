@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_MAT_RME_CONTROL'
define view entity ZC_MAT_RME_CONTROL
  as projection on zi_mat_rme_control
{

  key     Matnr,
  key     Omrme,
  key     ExpSecurity,
  key     ExportLicense,

          LicenseNumber,

          @ObjectModel.text.element: ['StatusText']
          @UI.textArrangement: #TEXT_ONLY
          Status,
          StatusText,

          /* Associations */
          _MatRme : redirected to parent ZC_MAT_RME
}
